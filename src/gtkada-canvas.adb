with Ada.Numerics.Elementary_Functions;  use Ada.Numerics.Elementary_Functions;
with Gdk.Color;        use Gdk.Color;
with Gdk.Drawable;     use Gdk.Drawable;
with Gdk.Event;        use Gdk.Event;
with Gdk.Font;         use Gdk.Font;
with Gdk.GC;           use Gdk.GC;
with Gdk.Pixmap;       use Gdk.Pixmap;
with Gdk.Types;        use Gdk.Types;
with Gdk.Types.Keysyms; use Gdk.Types.Keysyms;
with Gdk.Rectangle;    use Gdk.Rectangle;
with Gdk.Window;       use Gdk.Window;
with Glib;             use Glib;
with Gtk.Adjustment;   use Gtk.Adjustment;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;
with Gtk.Enums;        use Gtk.Enums;
with Gtk.Extra.PsFont; use Gtk.Extra.PsFont;
with Gtk.Handlers;     use Gtk.Handlers;
with Gtk.Main;         use Gtk.Main;
with Gtk.Style;        use Gtk.Style;
with Gtk.Viewport;     use Gtk.Viewport;
with Gtk.Widget;       use Gtk.Widget;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Gtk.Object;       use Gtk.Object;
with System;
with Unchecked_Deallocation;


package body Gtkada.Canvas is

   Class_Record : System.Address := System.Null_Address;
   --  This pointer will keep a pointer to the C 'class record' for
   --  gtk. To avoid allocating memory for each widget, this may be done
   --  only once, and reused.
   --  ??? This is a global variable.

   -----------------
   -- Subprograms --
   -----------------

   procedure Free is new Unchecked_Deallocation (String, String_Access);
   procedure Free is new Unchecked_Deallocation
     (Canvas_Link_List_Record, Canvas_Link_List);
   procedure Free is new Unchecked_Deallocation
     (Canvas_Link_Record'Class, Canvas_Link);
   procedure Free is new Unchecked_Deallocation
     (Canvas_Item_List_Record, Canvas_Item_List);

   package Event_Handler is new Gtk.Handlers.Return_Callback
     (Widget_Type => Interactive_Canvas_Record, Return_Type => Boolean);

   package Realize_Handler is new Gtk.Handlers.Callback
     (Widget_Type => Interactive_Canvas_Record);

   function Expose (Canvas : access Interactive_Canvas_Record'Class;
                    Event         : Gdk.Event.Gdk_Event)
                   return Boolean;
   --  Handle the expose events for a canvas.

   procedure Realized (Canvas : access Interactive_Canvas_Record'Class);
   --  Create all the graphic contexts required for the animation.

   procedure Update_Links
     (Canvas : access Interactive_Canvas_Record'Class;
      Window : Gdk_Window;
      GC     : in Gdk.GC.Gdk_GC;
      Item   : in Canvas_Item := null);
   --  Redraw all the links in the canvas.
   --  If Item is not null, only the links to or from Item are redrawn.

   function Configure_Handler
     (Canvas : access Interactive_Canvas_Record'Class)
     return Boolean;
   --  When the item is resized.

   function Button_Pressed (Canvas : access Interactive_Canvas_Record'Class;
                            Event : Gdk_Event)
                           return Boolean;
   --  Called when the user has pressed the mouse button in the canvas.
   --  This tests whether an item was selected.

   function Button_Release (Canvas : access Interactive_Canvas_Record'Class;
                            Event : Gdk_Event)
                           return Boolean;
   --  Called when the user has released the mouse button.
   --  If an item was selected, this refreshed the canvas.

   function Button_Motion (Canvas : access Interactive_Canvas_Record'Class;
                           Event : Gdk_Event)
                          return Boolean;
   --  Called when the user moves the mouse while a button is pressed.
   --  If an item was selected, the item is moved.

   function Key_Press (Canvas : access Interactive_Canvas_Record'Class;
                       Event : Gdk_Event)
                      return Boolean;
   --  Handle key events, to provide scrolling through Page Up, Page Down, and
   --  arrow keys.

   procedure Clip_Line
     (From  : access Canvas_Item_Record'Class;
      To_X  : in Gint;
      To_Y  : in Gint;
      X_Pos : in Gfloat;
      Y_Pos : in Gfloat;
      X_Out : out Gint;
      Y_Out : out Gint);
   --  Clip the line that goes from the middle of From to (To_X, To_Y).
   --  The intersection between that line and the border of From is returned
   --  in (X_Out, Y_Out).
   --  X_Pos and Y_Pos have the same meaning as Src_X_Pos and Src_Y_Pos in the
   --  link record.

   procedure Draw_Straight_Link
     (Canvas : access Interactive_Canvas_Record'Class;
      Window : Gdk_Window;
      GC     : in Gdk.GC.Gdk_GC;
      Link   : in Canvas_Link);
   --  Draw Link on the screen as a straight line.
   --  This link includes both an arrow head on its destination, and an
   --  optional text displayed approximatively in its middle.

   procedure Draw_Arc_Link (Canvas : access Interactive_Canvas_Record'Class;
                            Window : Gdk_Window;
                            GC     : in Gdk.GC.Gdk_GC;
                            Link   : in Canvas_Link);
   --  Draw Link on the screen.
   --  The link is drawn as a curved link (ie there is an extra handle in its
   --  middle).
   --  This link includes both an arrow head on its destination, and an
   --  optional text displayed approximatively in its middle.

   procedure Update_Adjustments
     (Canvas : access Interactive_Canvas_Record'Class;
      Xmax, Ymax : Gint := 0);
   --  Update the adjustments of the canvas.
   --  This also resizes the Canvas itself, so that scrolling is usable if
   --  the canvas was put in a Scrolled_Window.
   --  This is the main function used to provide scrolling in case the widget
   --  was inserted in a scrolled window.
   --  The bounds for the adjustments are automatically computed, unless
   --  Xmax or Ymax is different from 0, in which case these are taken as the
   --  maximal bounds.

   procedure Draw_Arrow_Head (Canvas : access Interactive_Canvas_Record'Class;
                              Window : Gdk_Window;
                              GC     : in Gdk.GC.Gdk_GC;
                              X, Y   : Gint;
                              Angle  : in Float);
   --  Draw an arrow head at the position (X, Y) on the canvas.
   --  Angle is the angle of the main axis of the arrow.

   procedure Draw_Annotation (Canvas : access Interactive_Canvas_Record'Class;
                              Window : Gdk_Window;
                              GC     : in Gdk.GC.Gdk_GC;
                              X, Y   : Gint;
                              Str    : String_Access);
   --  Print an annotation on the canvas.
   --  The annotation is centered around (X, Y).

   procedure Draw_On_Double_Buffer
     (Canvas : access Interactive_Canvas_Record'Class);
   --  Redraw everything on the double buffer.

   function Has_Link
     (Canvas    : access Interactive_Canvas_Record'Class;
      Src, Dest : access Canvas_Item_Record'Class;
      Side      : Link_Side;
      Offset    : Gint) return Boolean;
   --  Return True if there is already a link from Src to Dest with
   --  the specific side and offset specified in parameter.
   --  This is used to avoid having two link hidding each other.

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Canvas : out Interactive_Canvas) is
   begin
      Canvas := new Interactive_Canvas_Record;
      Gtkada.Canvas.Initialize (Canvas);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   Signals : constant chars_ptr_array :=
     (1 => New_String ("background_click"),
      2 => New_String ("item_selected"));
   --  Array of the signals created for this widget

   procedure Initialize (Canvas : access Interactive_Canvas_Record'Class) is
      Signal_Parameters : constant Signal_Parameter_Types :=
        (1 => (1 => Gtk.Gtk_Type_Gdk_Event),
         2 => (1 => Gtk.Gtk_Type_Pointer));
      --  the parameters for the above signals.
      --  This must be defined in this function rather than at the
      --  library-level, or the value of Gtk_Type_Gdk_Event is not yet
      --  initialized.

   begin
      --  Create the viewport.
      --  The adjustments will be added automatically when the canvas is
      --  put in a scrolled window.

      Gtk.Viewport.Initialize (Canvas, Null_Adjustment, Null_Adjustment);

      --  The following call is required to initialize the class record,
      --  and the new signals created for this widget.
      --  Note also that we keep Class_Record, so that the memory allocation
      --  is done only once.
      Gtk.Object.Initialize_Class_Record
        (Canvas, Signals, Class_Record, Signal_Parameters);

      Gtk_New (Canvas.Drawing_Area);
      Add (Canvas, Canvas.Drawing_Area);

      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "expose_event",
         Event_Handler.To_Marshaller (Expose'Access),
         Slot_Object => Canvas);
      Realize_Handler.Object_Connect
        (Canvas.Drawing_Area, "realize",
         Realize_Handler.To_Marshaller (Realized'Access),
         Slot_Object => Canvas);
      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "button_press_event",
         Event_Handler.To_Marshaller (Button_Pressed'Access),
         Slot_Object => Canvas);
      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "button_release_event",
         Event_Handler.To_Marshaller (Button_Release'Access),
         Slot_Object => Canvas);
      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "motion_notify_event",
         Event_Handler.To_Marshaller (Button_Motion'Access),
         Slot_Object => Canvas);
      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "key_press_event",
         Event_Handler.To_Marshaller (Key_Press'Access),
         Slot_Object => Canvas);
      Event_Handler.Object_Connect
        (Canvas.Drawing_Area, "configure_event",
         Event_Handler.To_Marshaller (Configure_Handler'Access),
         Slot_Object => Canvas);

      --  We want to be sure to get all the mouse events, that are required
      --  for the animation.

      Add_Events (Canvas.Drawing_Area, Gdk.Types.Button_Press_Mask
                  or Gdk.Types.Button_Motion_Mask
                  or Gdk.Types.Button_Release_Mask
                  or Gdk.Types.Key_Press_Mask
                  or Gdk.Types.Key_Release_Mask);
      Set_Flags (Canvas.Drawing_Area, Can_Focus);

      Canvas.Annotation_Font := new String'(Default_Annotation_Font);
      Canvas.Arrow_Angle
        := Float (Default_Arrow_Angle) * Ada.Numerics.Pi / 180.0;
   end Initialize;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Canvas : access Interactive_Canvas_Record;
      Grid_Size         : Guint := Default_Grid_Size;
      Annotation_Font   : String := Default_Annotation_Font;
      Annotation_Height : Gint := Default_Annotation_Height;
      Arc_Link_Offset   : Gint := Default_Arc_Link_Offset;
      Arrow_Angle       : Gint := Default_Arrow_Angle;
      Arrow_Length      : Gint := Default_Arrow_Length;
      Motion_Threshold  : Gint := Default_Motion_Threshold)
   is
   begin
      Canvas.Grid_Size := Grid_Size;
      if Grid_Size = 0 then
         Canvas.Align_On_Grid := False;
      end if;
      Free (Canvas.Annotation_Font);
      Canvas.Annotation_Font := new String'(Annotation_Font);
      Canvas.Annotation_Height := Annotation_Height;
      Canvas.Arc_Link_Offset := Float (Arc_Link_Offset);
      Canvas.Arrow_Angle := Float (Arrow_Angle) * Ada.Numerics.Pi / 180.0;
      Canvas.Arrow_Length := Float (Arrow_Length);
      Canvas.Motion_Threshold := Motion_Threshold;

      if Canvas.Font /= Null_Font then
         Unref (Canvas.Font);
      end if;
      Canvas.Font := Get_Gdkfont (Canvas.Annotation_Font.all,
                                  Canvas.Annotation_Height);
   end Configure;

   -----------------------
   -- Configure_Handler --
   -----------------------

   function Configure_Handler
     (Canvas : access Interactive_Canvas_Record'Class)
     return Boolean
   is
      use type Gdk_Pixmap;
   begin
      if Canvas.Double_Pixmap /= Null_Pixmap then
         Gdk.Pixmap.Unref (Canvas.Double_Pixmap);
      end if;

      Gdk.Pixmap.Gdk_New
        (Canvas.Double_Pixmap,
         Get_Window (Canvas.Drawing_Area),
         Gint (Get_Allocation_Width (Canvas.Drawing_Area)),
         Gint (Get_Allocation_Height (Canvas.Drawing_Area)));

      --  Clean and redraw everything in the canvas, if the canvas is
      --  displayed on the screen.

      Draw_On_Double_Buffer (Canvas);
      return True;
   end Configure_Handler;

   -------------------
   -- Align_On_Grid --
   -------------------

   procedure Align_On_Grid (Canvas : access Interactive_Canvas_Record;
                            Align  : Boolean := True)
   is
   begin
      Canvas.Align_On_Grid := (Canvas.Grid_Size /= 0) and then Align;
   end Align_On_Grid;

   ------------------------
   -- Update_Adjustments --
   ------------------------

   procedure Update_Adjustments
     (Canvas : access Interactive_Canvas_Record'Class;
      Xmax, Ymax : Gint := 0)
   is
      Current      : Canvas_Item_List := Canvas.Children;
      X_Max, Y_Max : Guint := Guint'First;
      Modified     : Boolean;
   begin
      --  Find the smallest bounding box for all the items in the canvas.
      --  Note that this does not include links, which might thus be found
      --  outside of this box, but this does not really matter.
      --  Note also that we do not handle widgets whose location has negative
      --  coordinates, which we thus forbid in Button_Motion.

      if Xmax = 0 or else Ymax = 0 then

         while Current /= null loop
            if Current.Item.Visible
              and then Guint (Current.Item.Coord.X) + Current.Item.Coord.Width
              > X_Max
            then
               X_Max :=
                 Guint (Current.Item.Coord.X) + Current.Item.Coord.Width;
            end if;

            if Current.Item.Visible
              and then Guint (Current.Item.Coord.Y) + Current.Item.Coord.Height
              > Y_Max
            then
               Y_Max :=
                 Guint (Current.Item.Coord.Y) + Current.Item.Coord.Height;
            end if;
            Current := Current.Next;
         end loop;
      end if;

      if Xmax /= 0 then
         X_Max := Guint (Xmax);
      end if;
      Modified := Canvas.Xmax /= Gint (X_Max);
      Canvas.Xmax := Gint (X_Max);

      if Ymax /= 0 then
         Y_Max := Guint (Ymax);
      end if;
      Modified := Modified or else (Canvas.Ymax /= Gint (Y_Max));
      Canvas.Ymax := Gint (Y_Max);

      --  Don't resize it if we already have the right size, for efficiency.

      if Modified then

         --  Resize the canvas, so that scrolling can take place.

         Size (Canvas.Drawing_Area,
               Canvas.Xmax + X_Thickness (Get_Style (Canvas)),
               Canvas.Ymax + Y_Thickness (Get_Style (Canvas)));

         --  Update the scrollbars.

         Set_Lower (Get_Hadjustment (Canvas), 0.0);
         Set_Upper (Get_Hadjustment (Canvas), Gfloat (Canvas.Xmax));
         Changed (Get_Hadjustment (Canvas));

         Set_Lower (Get_Vadjustment (Canvas), 0.0);
         Set_Upper (Get_Vadjustment (Canvas), Gfloat (Canvas.Ymax));
         Changed (Get_Vadjustment (Canvas));

      end if;
   end Update_Adjustments;

   -------------
   -- Move_To --
   -------------

   procedure Move_To
     (Canvas : access Interactive_Canvas_Record;
      Item   : access Canvas_Item_Record'Class;
      X, Y   : Glib.Gint := Glib.Gint'First)
   is
      Step  : Guint := Canvas.Grid_Size;

      function Location_Is_Free (X, Y : Gint) return Boolean;
      --  Return True if the location X, Y for the new item would be
      --  acceptable, or if it would cross an existing item.
      --  Keeps a space of at least Grid_Size around each item.

      ----------------------
      -- Location_Is_Free --
      ----------------------

      function Location_Is_Free (X, Y : Gint) return Boolean is
         Tmp   : Canvas_Item_List := Canvas.Children;
         Dest  : Gdk.Rectangle.Gdk_Rectangle;
         Inter : Boolean := False;
      begin
         Item.Coord.X := X - Gint (Step);
         Item.Coord.Y := Y - Gint (Step);
         Item.Coord.Width := Item.Coord.Width + 2 * Step - 1;
         Item.Coord.Height := Item.Coord.Height + 2 * Step - 1;

         while not Inter and then Tmp /= null loop

            if Tmp.Item.Visible
              and then Tmp.Item /= Canvas_Item (Item)
            then
               Intersect (Tmp.Item.Coord, Item.Coord, Dest, Inter);
            end if;
            Tmp := Tmp.Next;
         end loop;
         Item.Coord.Width := Item.Coord.Width - 2 * Step + 1;
         Item.Coord.Height := Item.Coord.Height - 2 * Step + 1;
         return not Inter;
      end Location_Is_Free;

      Src_Item : Canvas_Item := null;
      Links    : Canvas_Link_List := Canvas.Links;
      X1       : Gint;
      Y1       : Gint;

   begin
      --  When no grid is drawn...
      if Step = 0 then
         Step := Default_Grid_Size;
      end if;

      if X /= Gint'First and then Y /= Gint'First then
         Item.Coord.X := X;
         Item.Coord.Y := Y;
      else

         --  Check if there is any link that has for destination the widget we
         --  are adding.

         while Links /= null loop
            if Src_Item = null
              and then Links.Link.Dest = Canvas_Item (Item)
            then
               Src_Item := Links.Link.Src;
            end if;
            Links := Links.Next;
         end loop;

         --  The rule is the following when we have a link to an existing
         --  item: We first try to put the new item below the old
         --  one, then, if that place is already occupied, to the
         --  bottom-right, then the bottom-left, then two down, ...

         if Src_Item /= null then
            declare
               Num : Gint := 0;
            begin
               loop
                  X1 := Src_Item.Coord.X + ((Num + 1) mod 3 - 1)
                    * Gint (Step * 2 + Src_Item.Coord.Width);
                  Y1 := Src_Item.Coord.Y
                    + Gint (Src_Item.Coord.Height)
                    + (1 + Num / 3) * Gint (Step * 2);
                  if X1 >= 0 then
                     exit when Location_Is_Free (X1, Y1);
                  end if;
                  Num := Num + 1;
               end loop;
            end;

         --  Else put the item in the first line, at the first possible
         --  location

         else
            X1 := Gint (Step);
            Y1 := Gint (Step);
            while not Location_Is_Free (X1, Y1) loop
               X1 := X1 + Gint (Step) * 2;
            end loop;
         end if;

         Item.Coord.X := X1;
         Item.Coord.Y := Y1;
      end if;

      if Canvas.Align_On_Grid then
         Item.Coord.X := (Item.Coord.X / Gint (Canvas.Grid_Size))
           * Gint (Canvas.Grid_Size);
         Item.Coord.Y := (Item.Coord.Y / Gint (Canvas.Grid_Size))
           * Gint (Canvas.Grid_Size);
      end if;
   end Move_To;

   ---------
   -- Put --
   ---------

   procedure Put (Canvas : access Interactive_Canvas_Record;
                  Item   : access Canvas_Item_Record'Class;
                  X, Y   : Gint := Gint'First)
   is
   begin
      Canvas.Children := new Canvas_Item_List_Record
        '(Item => Canvas_Item (Item),
          Next => Canvas.Children);
      Move_To (Canvas, Item, X, Y);

      Update_Adjustments (Canvas);

      --  Change the adjustments so that the new item is automatically visible

      Clamp_Page (Get_Hadjustment (Canvas), Gfloat (Item.Coord.X),
                  Gfloat (Item.Coord.X + Gint (Item.Coord.Width)));
      Clamp_Page (Get_Vadjustment (Canvas), Gfloat (Item.Coord.Y),
                  Gfloat (Item.Coord.Y + Gint (Item.Coord.Height)));
      Draw_On_Double_Buffer (Canvas);
   end Put;

   --------------
   -- Realized --
   --------------

   procedure Realized (Canvas : access Interactive_Canvas_Record'Class) is
      use type Gdk.GC.Gdk_GC;
   begin

      --  Create all the graphic contexts if necessary.
      --  Set Exposures to False, since we want to handle the redraw
      --  events ourselves, and not have them generated automatically
      --  everytime we do a Draw_Pixmap (for optimization purposes)

      if Canvas.Black_GC = null then
         Set_Exposures
           (Get_Background_GC (Get_Style (Canvas), State_Normal), False);

         Gdk_New (Canvas.Black_GC, Get_Window (Canvas.Drawing_Area));
         Set_Foreground (Canvas.Black_GC,
                         Black (Gtk.Widget.Get_Default_Colormap));
         Set_Exposures (Canvas.Black_GC, False);

         Gdk_New (Canvas.Clear_GC, Get_Window (Canvas.Drawing_Area));
         Set_Foreground (Canvas.Clear_GC,
                         Get_Background (Get_Style (Canvas), State_Normal));
         Set_Exposures (Canvas.Clear_GC, False);

         --  Note: when setting the line attributes below, it is very important
         --  for the Line_Width to be 0 so has to get algorithms as fast as
         --  possible (1 is way too slow for a proper interaction with the
         --  user).
         Gdk_New (Canvas.Anim_GC, Get_Window (Canvas.Drawing_Area));
         Set_Function (Canvas.Anim_GC, Invert);
         Set_Line_Attributes (Canvas.Anim_GC,
                              Line_Width => 0,
                              Line_Style => Line_On_Off_Dash,
                              Cap_Style  => Cap_Butt,
                              Join_Style => Join_Miter);
         Set_Exposures (Canvas.Anim_GC, False);

         Canvas.Font := Get_Gdkfont (Canvas.Annotation_Font.all,
                                     Canvas.Annotation_Height);
         if Canvas.Font = Null_Font then
            null;  --  ??  Should use a default font
         end if;
      end if;

      Draw_On_Double_Buffer (Canvas);
   end Realized;

   -------------------
   -- For_Each_Item --
   -------------------

   procedure For_Each_Item (Canvas  : access Interactive_Canvas_Record;
                            Execute : Item_Processor)
   is
      Item     : Canvas_Item_List := Canvas.Children;
      Tmp      : Canvas_Item_List;
   begin
      while Item /= null loop
         Tmp := Item.Next;
         exit when not  Execute (Canvas, Item.Item);
         Item := Tmp;
      end loop;
   end For_Each_Item;

   ---------------
   -- Clip_Line --
   ---------------

   procedure Clip_Line (From  : access Canvas_Item_Record'Class;
                        To_X  : in Gint;
                        To_Y  : in Gint;
                        X_Pos : in Gfloat;
                        Y_Pos : in Gfloat;
                        X_Out : out Gint;
                        Y_Out : out Gint)
   is
      Src_X : constant Gint :=
        From.Coord.X + Gint (Gfloat (From.Coord.Width) * X_Pos);
      Src_Y : constant Gint :=
        From.Coord.Y + Gint (Gfloat (From.Coord.Height) * Y_Pos);
      Delta_X  : constant Gint := To_X - Src_X;
      Delta_Y  : constant Gint := To_Y - Src_Y;

      Offset : Gint;
   begin
      --  Intersection with horizontal sides
      if Delta_Y /= 0 then
         Offset := (Src_X * To_Y - To_X * Src_Y);
         if Delta_Y < 0 then
            --  Intersection with north side ?
            Y_Out := From.Coord.Y;
         else
            Y_Out := From.Coord.Y + Gint (From.Coord.Height);
         end if;

         X_Out := (Delta_X * Y_Out + Offset) / Delta_Y;
         if From.Coord.X <= X_Out
           and then X_Out <= From.Coord.X + Gint (From.Coord.Width)
         then
            return;
         end if;
      end if;

      --  Intersection with vertical sides
      if Delta_X /= 0 then
         Offset := (To_X * Src_Y - Src_X * To_Y);
         if Delta_X < 0 then
            --  Intersection with West side ?
            X_Out := From.Coord.X;
         else
            --  Intersection with East side ?
            X_Out := From.Coord.X + Gint (From.Coord.Width);
         end if;

         Y_Out := (Delta_Y * X_Out + Offset) / Delta_X;
         if From.Coord.Y <= Y_Out
           and then Y_Out <= From.Coord.Y + Gint (From.Coord.Height)
         then
            return;
         end if;
      end if;

      X_Out := 0;
      Y_Out := 0;
   end Clip_Line;

   ---------------------
   -- Draw_Arrow_Head --
   ---------------------

   procedure Draw_Arrow_Head (Canvas : access Interactive_Canvas_Record'Class;
                              Window : Gdk_Window;
                              GC     : in Gdk.GC.Gdk_GC;
                              X, Y   : Gint;
                              Angle  : in Float)
   is
   begin
      Draw_Polygon
        (Window,
         GC,
         Filled => True,
         Points =>
           ((X => X, Y => Y),
            (X => X
             + Gint (Canvas.Arrow_Length * Cos (Angle + Canvas.Arrow_Angle)),
             Y => Y
             + Gint (Canvas.Arrow_Length * Sin (Angle + Canvas.Arrow_Angle))),
            (X => X
             + Gint (Canvas.Arrow_Length * Cos (Angle - Canvas.Arrow_Angle)),
             Y => Y
             + Gint (Canvas.Arrow_Length
                     * Sin (Angle - Canvas.Arrow_Angle)))));
   end Draw_Arrow_Head;

   ---------------------
   -- Draw_Annotation --
   ---------------------

   procedure Draw_Annotation (Canvas : access Interactive_Canvas_Record'Class;
                              Window : Gdk_Window;
                              GC     : in Gdk.GC.Gdk_GC;
                              X, Y   : Gint;
                              Str    : String_Access)
   is
   begin
      Draw_Text (Window,
                 Canvas.Font,
                 GC,
                 X    => X - String_Width (Canvas.Font, Str.all) / 2,
                 Y    => Y - String_Height (Canvas.Font, Str.all) / 2,
                 Text => Str.all);
   end Draw_Annotation;

   ------------------------
   -- Draw_Straight_Link --
   ------------------------

   procedure Draw_Straight_Link
     (Canvas : access Interactive_Canvas_Record'Class;
      Window : Gdk_Window;
      GC     : in Gdk.GC.Gdk_GC;
      Link   : in Canvas_Link)
   is
      X1, Y1, X2, Y2 : Gint;
   begin
      Clip_Line
        (Link.Src,
         Link.Dest.Coord.X
            + Gint (Gfloat (Link.Dest.Coord.Width) * Link.Dest_X_Pos),
         Link.Dest.Coord.Y
            + Gint (Gfloat (Link.Dest.Coord.Height) * Link.Dest_Y_Pos),
         X_Pos => Link.Src_X_Pos, Y_Pos => Link.Src_Y_Pos,
         X_Out => X1, Y_Out => Y1);
      Clip_Line
        (Link.Dest,
         Link.Src.Coord.X
            + Gint (Gfloat (Link.Src.Coord.Width) * Link.Src_X_Pos),
         Link.Src.Coord.Y
            + Gint (Gfloat (Link.Src.Coord.Height) * Link.Src_Y_Pos),
         X_Pos => Link.Dest_X_Pos, Y_Pos => Link.Dest_Y_Pos,
         X_Out => X2, Y_Out => Y2);

      --  Draw the link itself

      Draw_Line (Window, GC, X1, Y1, X2, Y2);

      --  Draw the end arrow head

      if Link.Arrow = End_Arrow or else Link.Arrow = Both_Arrow then

         if X1 /= X2 then
            Draw_Arrow_Head (Canvas, Window, GC, X2, Y2,
                             Arctan (Float (Y1 - Y2), Float (X1 - X2)));
         elsif Y1 > Y2 then
            Draw_Arrow_Head
              (Canvas, Window, GC, X2, Y2, Ada.Numerics.Pi / 2.0);
         else
            Draw_Arrow_Head
              (Canvas, Window, GC, X2, Y2, -Ada.Numerics.Pi / 2.0);
         end if;
      end if;

      --  Draw the start arrow head

      if Link.Arrow = Start_Arrow or else Link.Arrow = Both_Arrow then

         if X1 /= X2 then
            Draw_Arrow_Head (Canvas, Window, GC, X1, Y1,
                             Arctan (Float (Y2 - Y1), Float (X2 - X1)));
         elsif Y1 > Y2 then
            Draw_Arrow_Head
              (Canvas, Window, GC, X1, Y1, -Ada.Numerics.Pi / 2.0);
         else
            Draw_Arrow_Head
              (Canvas, Window, GC, X1, Y1, +Ada.Numerics.Pi / 2.0);
         end if;
      end if;

      --  Draw the text if any

      if Link.Descr /= null then
         Draw_Annotation (Canvas, Window, GC,
                          (X1 + X2) / 2,
                          (Y1 + Y2) / 2,
                          Link.Descr);
      end if;

   end Draw_Straight_Link;

   -------------------
   -- Draw_Arc_Link --
   -------------------

   procedure Draw_Arc_Link (Canvas : access Interactive_Canvas_Record'Class;
                            Window : Gdk_Window;
                            GC     : in Gdk.GC.Gdk_GC;
                            Link   : in Canvas_Link)
   is
      X1, Y1, X2, Y2, X3, Y3 : Gint;
      --  The three points that define the arc

      procedure Center (Center_X, Center_Y : out Gint);
      --  Compute the center of the circle that encloses the three points
      --  defined by (X1, Y1), (X2, Y2) or (X3, Y3).
      --  Center_X is set to Gint'First if the points are colinear

      ------------
      -- Center --
      ------------

      procedure Center (Center_X, Center_Y : out Gint)
      is
         A : constant Gint := X2 - X1;
         B : constant Gint := Y2 - Y1;
         C : constant Gint := X3 - X1;
         D : constant Gint := Y3 - Y1;
         E : constant Gint := A * (X1 + X2) + B * (Y1 + Y2);
         F : constant Gint := C * (X1 + X3) + D * (Y1 + Y3);
         G : constant Gint := 2 * (A * (Y3 - Y2) - B * (X3 - X2));
      begin
         --  Are the points colinear ? We just choose a circle that
         --  goes through two of them.

         if G = 0 then
            if A = 0 and then B = 0 then
               Center_X := (X1 + X3) / 2;
               Center_Y := (Y1 + Y3) / 2;
            else
               Center_X := (X2 + X3) / 2;
               Center_Y := (Y2 + Y3) / 2;
            end if;
            return;
         end if;

         Center_X := (D * E - B * F) / G;
         Center_Y := (A * F - C * E) / G;
      end Center;

      use type Gdk.GC.Gdk_GC;
      Offset_X, Offset_Y : Gint;
      Right_Angle : constant Float := Ada.Numerics.Pi / 2.0;
      --  The offsets to use to calculate the position of the middle point.

      Xc, Yc     : Gint;
      Radius     : Gint;
      Base       : constant := 360 * 64;
      Float_Base : constant := 180.0 * 64.0 / Ada.Numerics.Pi;
      Angle      : Float;
      Angle_From : Gint;
      Angle_To   : Gint;
      Path       : Gint;
   begin

      --  Special case for self-referencing links

      if Link.Src = Link.Dest then
         Xc := Link.Src.Coord.X + Gint (Link.Src.Coord.Width);
         Yc := Link.Src.Coord.Y;
         Radius := Gint (Canvas.Arc_Link_Offset) / 2 * Link.Offset;
         Angle_From := -90 * 64;
         Path       := 270 * 64;

         --  Location of the arrow
         X3 := Xc - Radius;
         Y3 := Yc;
         X1 := Xc;
         Y1 := Yc + Radius;

         --  Location of the annotation
         X2 := Xc + Radius / 2;
         Y2 := Yc - Radius / 2;

      else

         --  We will first compute the extra intermediate point between the
         --  center of the two items. Once we have this intermediate point, we
         --  will be able to use the intersection point between the two items
         --  and the two lines from the centers to the middle point.  Finally,
         --  we will be able to compute the circle enclosing the three points.

         X1 := Link.Src.Coord.X
           + Gint (Gfloat (Link.Src.Coord.Width) * Link.Src_X_Pos);
         Y1 := Link.Src.Coord.Y
           + Gint (Gfloat (Link.Src.Coord.Height) * Link.Src_Y_Pos);
         X3 := Link.Dest.Coord.X
           + Gint (Gfloat (Link.Dest.Coord.Width) * Link.Dest_X_Pos);
         Y3 := Link.Dest.Coord.Y
           + Gint (Gfloat (Link.Dest.Coord.Height) * Link.Dest_Y_Pos);

         --  Compute the middle point for the arc, and create a dummy item for
         --  it that the user can move.

         if X1 /= X3 then
            Angle := Arctan (Float (Y3 - Y1), Float (X3 - X1));
         elsif Y3 > Y1 then
            Angle := Ada.Numerics.Pi / 2.0;
         else
            Angle := -Ada.Numerics.Pi / 2.0;
         end if;
         if Link.Side = Right then
            Offset_X := Gint (Canvas.Arc_Link_Offset
                              * Cos (Angle - Right_Angle));
            Offset_Y := Gint (Canvas.Arc_Link_Offset
                              * Sin (Angle - Right_Angle));
         else
            Offset_X := Gint (Canvas.Arc_Link_Offset
                              * Cos (Angle + Right_Angle));
            Offset_Y := Gint (Canvas.Arc_Link_Offset
                              * Sin (Angle + Right_Angle));
         end if;

         X2 := (X1 + X3) / 2 + Offset_X * Link.Offset;
         Y2 := (Y1 + Y3) / 2 + Offset_Y * Link.Offset;

         --  Clip to the border of the boxes

         Clip_Line (Link.Src, X2, Y2,
                    X_Pos => Link.Src_X_Pos, Y_Pos => Link.Src_Y_Pos,
                    X_Out => X1, Y_Out => Y1);
         Clip_Line (Link.Dest, X2, Y2,
                    X_Pos => Link.Dest_X_Pos, Y_Pos => Link.Dest_Y_Pos,
                    X_Out => X3, Y_Out => Y3);

         --  Compute the circle's center and radius

         Center (Xc, Yc);
         Radius := Gint (Sqrt (Float ((Xc - X3) * (Xc - X3)
                                      + (Yc - Y3) * (Yc - Y3))));

         --  Compute the angles

         if X1 /= Xc then
            Angle_From :=
              (Gint (Float_Base * Arctan (Float (Yc - Y1), Float (X1 - Xc)))
               + Base) mod Base;
         elsif Yc > Y1 then
            Angle_From := Base / 4;
         else
            Angle_From := -Base / 4;
         end if;

         if X3 /= Xc then
            Angle_To   :=
              (Gint (Float_Base * Arctan (Float (Yc - Y3), Float (X3 - Xc)))
               + Base) mod Base;
         elsif Yc > Y3 then
            Angle_To := Base / 4;
         else
            Angle_To := -Base / 4;
         end if;

         Path := (Base + Angle_To - Angle_From) mod Base;

         --  Make sure we chose the shortest arc

         if Path > Base / 2 then
            Path := Path - Base;
         end if;

      end if;

      --  Draw the arc

      Draw_Arc (Window,
                GC,
                Filled => False,
                X      => Xc - Radius,
                Y      => Yc - Radius,
                Width  => Radius * 2,
                Height => Radius * 2,
                Angle1 => Angle_From,
                Angle2 => Path);

      --  Draw the arrows

      if Link.Arrow = End_Arrow or else Link.Arrow = Both_Arrow then
         if X3 /= Xc then
            Angle := Arctan (Float (Y3 - Yc), Float (X3 - Xc));
         elsif Y3 > Yc then
            Angle := Right_Angle;
         else
            Angle := -Right_Angle;
         end if;

         if Path > 0 then
            Angle := Angle + Right_Angle;
         else
            Angle := Angle - Right_Angle;
         end if;

         Draw_Arrow_Head (Canvas, Window, GC, X3, Y3, Angle);
      end if;

      if Link.Arrow = Start_Arrow or else Link.Arrow = Both_Arrow then
         if X1 /= Xc then
            Angle := Arctan (Float (Y1 - Yc), Float (X1 - Xc));
         elsif Y1 > Yc then
            Angle := Right_Angle;
         else
            Angle := -Right_Angle;
         end if;

         if Path > 0 then
            Angle := Angle - Right_Angle;
         else
            Angle := Angle + Right_Angle;
         end if;

         Draw_Arrow_Head (Canvas, Window, GC, X1, Y1, Angle);
      end if;

      --  Draw the text if any

      if Link.Descr /= null then
         Draw_Annotation (Canvas, Window, GC, X2, Y2, Link.Descr);
      end if;

   end Draw_Arc_Link;

   ------------------
   -- Update_Links --
   ------------------

   procedure Update_Links
     (Canvas : access Interactive_Canvas_Record'Class;
      Window : Gdk_Window;
      GC     : in Gdk.GC.Gdk_GC;
      Item   : in Canvas_Item := null)
   is
      Current : Canvas_Link_List := Canvas.Links;
   begin
      while Current /= null loop
         if Item = null
           or else Current.Link.Src = Canvas_Item (Item)
           or else Current.Link.Dest = Canvas_Item (Item)
         then
            if Is_Visible (Current.Link.Src)
              and then Is_Visible (Current.Link.Dest)
            then
               if Current.Link.Side = Straight then
                  Draw_Straight_Link (Canvas, Window, GC, Current.Link);
               else
                  Draw_Arc_Link (Canvas, Window, GC, Current.Link);
               end if;
            end if;
         end if;
         Current := Current.Next;
      end loop;
   end Update_Links;

   ---------------------------
   -- Draw_On_Double_Buffer --
   ---------------------------

   procedure Draw_On_Double_Buffer
     (Canvas : access Interactive_Canvas_Record'Class)
   is
      use type Gdk_GC;
      Tmp : Canvas_Item_List := Canvas.Children;
      X : Guint := Canvas.Grid_Size;
      Y : Guint := Canvas.Grid_Size;
      W, H : Gint;
   begin
      --  If the GC was not created, do not do anything

      if Canvas.Clear_GC = Null_GC then
         return;
      end if;

      --  Clear the canvas

      Get_Size (Canvas.Double_Pixmap, W, H);
      Draw_Rectangle
        (Canvas.Double_Pixmap,
         Get_Background_GC (Get_Style (Canvas), State_Normal),
         Filled => True,
         X => 0, Y => 0,
         Width  => Gint (W),
         Height => Gint (H));

      --  Draw the background dots.

      if Canvas.Grid_Size /= 0 then
         while Y < Get_Allocation_Height (Canvas.Drawing_Area) loop
            X := Canvas.Grid_Size;
            while X < Get_Allocation_Width (Canvas.Drawing_Area) loop
               Draw_Point (Canvas.Double_Pixmap,
                           GC       => Canvas.Black_GC,
                           X        => Gint (X),
                           Y        => Gint (Y));
               X := X + Canvas.Grid_Size;
            end loop;
            Y := Y + Canvas.Grid_Size;
         end loop;
      end if;

      --  Draw the links first, so that they appear to be below the items.

      Update_Links (Canvas, Canvas.Double_Pixmap, Canvas.Black_GC);

      --  Draw each of the items.

      while Tmp /= null loop
         if Tmp.Item.Visible then
            Draw_Pixmap (Canvas.Double_Pixmap,
                         GC      => Canvas.Black_GC,
                         Src     => Pixmap (Tmp.Item),
                         Xsrc    => 0,
                         Ysrc    => 0,
                         Xdest   => Tmp.Item.Coord.X,
                         Ydest   => Tmp.Item.Coord.Y);
         end if;
         Tmp := Tmp.Next;
      end loop;

      Queue_Draw (Canvas.Drawing_Area);
   end Draw_On_Double_Buffer;

   ------------
   -- Expose --
   ------------

   function Expose (Canvas : access Interactive_Canvas_Record'Class;
                    Event         : Gdk.Event.Gdk_Event)
                   return Boolean
   is
      Area : Gdk_Rectangle := Get_Area (Event);
   begin
      Gdk.Drawable.Copy_Area
        (Get_Window (Canvas.Drawing_Area),
         Canvas.Black_GC,
         X        => Area.X,
         Y        => Area.Y,
         Source   => Canvas.Double_Pixmap,
         Source_X => Area.X,
         Source_Y => Area.Y,
         Width    => Gint (Area.Width),
         Height   => Gint (Area.Height));
      return False;
   end Expose;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Item   : access Canvas_Item_Record'Class;
                         Win    : Gdk_Window;
                         Width  : Gint;
                         Height : Gint)
   is
      use type Gdk.Pixmap.Gdk_Pixmap;
   begin
      Item.Coord.Width  := Guint (Width);
      Item.Coord.Height := Guint (Height);

      --  Create the pixmap
      if Item.Pixmap /= Null_Pixmap then
         Gdk.Pixmap.Unref (Item.Pixmap);
      end if;

      Gdk_New (Item.Pixmap, Win, Width, Height);
   end Initialize;

   ---------------
   -- Key_Press --
   ---------------

   function Key_Press (Canvas : access Interactive_Canvas_Record'Class;
                       Event : Gdk_Event)
                      return Boolean
   is
      Value : constant Gfloat := Get_Value (Get_Vadjustment (Canvas));
      Upper : constant Gfloat := Get_Upper (Get_Vadjustment (Canvas));
      Lower : constant Gfloat := Get_Lower (Get_Vadjustment (Canvas));
      Page_Incr : constant Gfloat :=
        Get_Page_Increment (Get_Vadjustment (Canvas));
      Page_Size : constant Gfloat :=
        Get_Page_Size (Get_Vadjustment (Canvas));
      Step_Incr : constant Gfloat :=
        Get_Step_Increment (Get_Vadjustment (Canvas));
   begin
      case Get_Key_Val (Event) is
         when GDK_Home =>
            Set_Value (Get_Vadjustment (Canvas), Lower);
            Changed (Get_Vadjustment (Canvas));
            return True;

         when GDK_End =>
            Set_Value (Get_Vadjustment (Canvas), Upper - Page_Size);
            Changed (Get_Vadjustment (Canvas));
            return True;

         when GDK_Page_Up =>
            if Value >= Lower + Page_Incr then
               Set_Value (Get_Vadjustment (Canvas), Value - Page_Incr);
            else
               Set_Value (Get_Vadjustment (Canvas), Lower);
            end if;
            Changed (Get_Vadjustment (Canvas));
            return True;

         when GDK_Page_Down =>
            if Value + Page_Incr + Page_Size <= Upper then
               Set_Value (Get_Vadjustment (Canvas), Value + Page_Incr);
            else
               Set_Value (Get_Vadjustment (Canvas), Upper - Page_Size);
            end if;
            Changed (Get_Vadjustment (Canvas));
            return True;

         when GDK_Up | GDK_KP_Up =>
            if Value - Step_Incr >= Lower then
               Set_Value (Get_Vadjustment (Canvas), Value - Step_Incr);
            else
               Set_Value (Get_Vadjustment (Canvas), Lower);
            end if;
            Changed (Get_Vadjustment (Canvas));
            Emit_Stop_By_Name (Canvas.Drawing_Area, "key_press_event");
            return True;

         when GDK_Down | GDK_KP_Down =>
            if Value + Step_Incr + Page_Size <= Upper then
               Set_Value (Get_Vadjustment (Canvas), Value + Step_Incr);
            else
               Set_Value (Get_Vadjustment (Canvas), Upper - Page_Size);
            end if;
            Changed (Get_Vadjustment (Canvas));
            Emit_Stop_By_Name (Canvas.Drawing_Area, "key_press_event");
            return True;

         when GDK_Left | GDK_KP_Left =>
            if Get_Value (Get_Hadjustment (Canvas))
              - Get_Step_Increment (Get_Hadjustment (Canvas))
              >= Get_Lower (Get_Hadjustment (Canvas))
            then
               Set_Value (Get_Hadjustment (Canvas),
                          Get_Value (Get_Hadjustment (Canvas))
                          - Get_Step_Increment (Get_Hadjustment (Canvas)));
            else
               Set_Value (Get_Hadjustment (Canvas),
                          Get_Lower (Get_Hadjustment (Canvas)));
            end if;
            Changed (Get_Hadjustment (Canvas));
            Emit_Stop_By_Name (Canvas.Drawing_Area, "key_press_event");
            return True;

         when GDK_Right | GDK_KP_Right =>
            if Get_Value (Get_Hadjustment (Canvas))
              + Get_Step_Increment (Get_Hadjustment (Canvas))
              + Get_Page_Size (Get_Hadjustment (Canvas))
              <= Get_Upper (Get_Hadjustment (Canvas))
            then
               Set_Value (Get_Hadjustment (Canvas),
                          Get_Value (Get_Hadjustment (Canvas))
                          + Get_Step_Increment (Get_Hadjustment (Canvas)));
            else
               Set_Value (Get_Hadjustment (Canvas),
                          Get_Upper (Get_Hadjustment (Canvas))
                          - Get_Page_Size (Get_Hadjustment (Canvas)));
            end if;
            Changed (Get_Hadjustment (Canvas));
            Emit_Stop_By_Name (Canvas.Drawing_Area, "key_press_event");
            return True;

         when others =>
            null;
      end case;
      return False;
   end Key_Press;

   --------------------
   -- Button_Pressed --
   --------------------

   function Button_Pressed (Canvas : access Interactive_Canvas_Record'Class;
                            Event : Gdk_Event)
                           return Boolean
   is
      Tmp : Canvas_Item_List := Canvas.Children;
      X : Gint := Gint (Get_X (Event));
      Y : Gint := Gint (Get_Y (Event));

      procedure Emit_By_Name_Item
        (Object : in System.Address;
         Name   : in String;
         Param  : in Canvas_Item);
      pragma Import (C, Emit_By_Name_Item, "gtk_signal_emit_by_name");

   begin

      Grab_Focus (Canvas.Drawing_Area);
      Set_Flags (Canvas.Drawing_Area, Has_Focus);

      Clear_Selection (Canvas);

      --  Find the selected item.

      while Tmp /= null loop
         if Tmp.Item.Visible
           and then X >= Tmp.Item.Coord.X
           and then X <= Tmp.Item.Coord.X + Gint (Tmp.Item.Coord.Width)
           and then Y >= Tmp.Item.Coord.Y
           and then Y <= Tmp.Item.Coord.Y + Gint (Tmp.Item.Coord.Height)
         then
            Add_To_Selection (Canvas, Tmp.Item);
            exit;
         end if;
         Tmp := Tmp.Next;
      end loop;

      --  If there was none, nothing to do...

      if Canvas.Selection = null then
         Realize_Handler.Emit_By_Name (Canvas, "background_click", Event);
         return False;
      end if;

      --  Double-click events are transmitted directly to the item, and are
      --  not used to move an item.

      if Get_Event_Type (Event) = Gdk_2button_Press then
         Set_X (Event,
                Get_X (Event) - Gdouble (Canvas.Selection.Item.Coord.X));
         Set_Y (Event,
                Get_Y (Event) - Gdouble (Canvas.Selection.Item.Coord.Y));
         On_Button_Click (Canvas.Selection.Item, Event);
         Clear_Selection (Canvas);
         return False;
      end if;

      --  Only left mouse button clicks can select an item

      if Get_Button (Event) /= 1 then
         --  Call the callbacks

         Set_X (Event,
                Get_X (Event) - Gdouble (Canvas.Selection.Item.Coord.X));
         Set_Y (Event,
                Get_Y (Event) - Gdouble (Canvas.Selection.Item.Coord.Y));
         On_Button_Click (Canvas.Selection.Item, Event);
         Clear_Selection (Canvas);
         return False;
      end if;

      --  Warn the user that a selection has been made

      Emit_By_Name_Item
        (Gtk.Get_Object (Canvas), "item_selected" & ASCII.NUL,
         Canvas.Selection.Item);

      --  Initialize the move

      Canvas.Last_X_Event := Gint (Get_X_Root (Event));
      Canvas.Last_Y_Event := Gint (Get_Y_Root (Event));
      Canvas.Mouse_Has_Moved := False;

      --  Make sure that no other widget steal the events while we are
      --  moving an item.

      Grab_Add (Canvas.Drawing_Area);

      return False;
   end Button_Pressed;

   --------------------
   -- Button_Release --
   --------------------

   function Button_Release (Canvas : access Interactive_Canvas_Record'Class;
                            Event : Gdk_Event)
                           return Boolean
   is
      Tmp : Canvas_Item_List := Canvas.Children;
      Delta_X, Delta_Y : Gint := 0;
      Min_X, Min_Y : Gint := Gint'Last;
      Selected : Canvas_Item_List;
      W, H : Gint;
      Max_X, Max_Y : Gint := Gint'First;
   begin

      Grab_Remove (Canvas.Drawing_Area);

      if Canvas.Selection = null then
         Realize_Handler.Emit_By_Name (Canvas, "background_click", Event);
         return False;
      end if;

      if Canvas.Mouse_Has_Moved then

         W := Gint (Get_Allocation_Width (Canvas));
         H := Gint (Get_Allocation_Height (Canvas));

         Tmp := Canvas.Children;
         while Tmp /= null loop
            if Tmp.Item.Visible then
               Min_X := Gint'Min (Min_X, Tmp.Item.Coord.X);
               Max_X := Gint'Max
                 (Max_X,
                  Tmp.Item.Coord.X + Gint (Tmp.Item.Coord.Width));

               Min_Y := Gint'Min (Min_Y, Tmp.Item.Coord.Y);
               Max_Y := Gint'Max
                 (Max_Y,
                  Tmp.Item.Coord.Y + Gint (Tmp.Item.Coord.Height));
            end if;
            Tmp := Tmp.Next;
         end loop;

         --  If one of the items is out of the canvas on the left
         --  (Min_X < 0), or if the items are two widely spaced (wider than
         --  the canvas itself), then align the left-most item to the left
         --  of the canvas.

         if Min_X < Gint (Canvas.Grid_Size)
           or else Max_X - Min_X + 2 * Gint (Canvas.Grid_Size) > W
         then
            Delta_X := Gint (Canvas.Grid_Size) - Min_X;

            --  Else, if one item is too much to the right, align it on the
            --  right of the canvas. Note that we know this won't force another
            --  one outside of the right.
         elsif Max_X > W then
            Delta_X := W - Max_X - Gint (Canvas.Grid_Size);
         end if;

         if Min_Y < Gint (Canvas.Grid_Size)
           or else Max_Y - Min_Y + 2 * Gint (Canvas.Grid_Size) > H
         then
            Delta_Y := Gint (Canvas.Grid_Size) - Min_Y;
         elsif Max_Y > H then
            Delta_Y := H - Max_Y - Gint (Canvas.Grid_Size);
         end if;

         --  Move all the items by the appropriate amount, and align them on
         --  the grid if required.

         Tmp := Canvas.Children;
         while Tmp /= null loop
            Tmp.Item.Coord.X := Tmp.Item.Coord.X + Delta_X;
            Tmp.Item.Coord.Y := Tmp.Item.Coord.Y + Delta_Y;
            if Canvas.Align_On_Grid then
               Tmp.Item.Coord.X := Tmp.Item.Coord.X
                 - Tmp.Item.Coord.X mod Gint (Canvas.Grid_Size);
               Tmp.Item.Coord.Y := Tmp.Item.Coord.Y
                 - Tmp.Item.Coord.Y mod Gint (Canvas.Grid_Size);
            end if;
            Tmp := Tmp.Next;
         end loop;

         Update_Adjustments (Canvas, Max_X + Delta_X, Max_Y + Delta_Y);
         Draw_On_Double_Buffer (Canvas);

         --  Scroll the canvas so as to show the right-most item from the
         --  selection
         Show_Item (Canvas, Canvas.Selection.Item);

      --  If the user did not move the mouse while it was pressed, this is
      --  because he only wanted to select the item.

      else
         Selected := Canvas.Selection;
         while Selected /= null loop
            Set_X (Event,
                   Get_X (Event) - Gdouble (Selected.Item.Coord.X));
            Set_Y (Event,
                   Get_Y (Event) - Gdouble (Selected.Item.Coord.Y));
            On_Button_Click (Selected.Item, Event);

            Selected := Selected.Next;
         end loop;
      end if;

      --  Other widgets can now receive events as well.

      return False;
   end Button_Release;

   -------------------
   -- Button_Motion --
   -------------------

   function Button_Motion (Canvas : access Interactive_Canvas_Record'Class;
                           Event : Gdk_Event)
                          return Boolean
   is
      use type Gdk.Window.Gdk_Window;
      Delta_X : Gint;
      Delta_Y : Gint;
      Selected : Canvas_Item_List;
      Item    : Canvas_Item;
      X, Y    : Gint;

   begin
      if Canvas.Selection = null then
         return False;
      end if;

      Delta_X := Gint (Get_X_Root (Event)) - Canvas.Last_X_Event;
      Delta_Y := Gint (Get_Y_Root (Event)) - Canvas.Last_Y_Event;

      if not Canvas.Mouse_Has_Moved then
         --  Should this be considered as a mouse motion, or simply an item
         --  selection ?

         if abs (Delta_X) <= Canvas.Motion_Threshold
           and then abs (Delta_Y) <= Canvas.Motion_Threshold
         then
            return False;
         end if;

      else
         Selected := Canvas.Selection;
         while Selected /= null loop
            Item := Selected.Item;

            --  Delete the currently dashed lines

            if Item.Visible then
               if Canvas.Align_On_Grid then
                  X := Item.Coord.X;
                  Y := Item.Coord.Y;
                  Item.Coord.X := Item.Coord.X
                    - Item.Coord.X mod Gint (Canvas.Grid_Size);
                  Item.Coord.Y := Item.Coord.Y
                    - Item.Coord.Y mod Gint (Canvas.Grid_Size);
               end if;

               Draw_Rectangle (Get_Window (Canvas.Drawing_Area),
                               GC     => Canvas.Anim_GC,
                               Filled => False,
                               X      => Item.Coord.X,
                               Y      => Item.Coord.Y,
                               Width  => Gint (Item.Coord.Width) - 1,
                               Height => Gint (Item.Coord.Height) - 1);
               Update_Links
                 (Canvas, Get_Window (Canvas.Drawing_Area),
                  Canvas.Anim_GC, Item);

               if Canvas.Align_On_Grid then
                  Item.Coord.X := X;
                  Item.Coord.Y := Y;
               end if;
            end if;


            Selected := Selected.Next;
         end loop;
      end if;

      Canvas.Mouse_Has_Moved := True;

      Selected := Canvas.Selection;
      while Selected /= null loop
         Item := Selected.Item;

         --  Move everything

         Canvas.Last_X_Event := Gint (Get_X_Root (Event));
         Canvas.Last_Y_Event := Gint (Get_Y_Root (Event));
         Item.Coord.X := Item.Coord.X + Delta_X;
         Item.Coord.Y := Item.Coord.Y + Delta_Y;

         --  Redraw the dashed lines in a new position
         --  Note that in the case of Align_On_Grid, we do not want to
         --  constrain the item location now, since this wouldn't work.

         if Item.Visible then
            if Canvas.Align_On_Grid then
               X := Item.Coord.X;
               Y := Item.Coord.Y;
               Item.Coord.X := Item.Coord.X
                 - Item.Coord.X mod Gint (Canvas.Grid_Size);
               Item.Coord.Y := Item.Coord.Y
                 - Item.Coord.Y mod Gint (Canvas.Grid_Size);
            end if;

            Draw_Rectangle (Get_Window (Canvas.Drawing_Area),
                            GC     => Canvas.Anim_GC,
                            Filled => False,
                            X      => Item.Coord.X,
                            Y      => Item.Coord.Y,
                            Width  => Gint (Item.Coord.Width) - 1,
                            Height => Gint (Item.Coord.Height) - 1);

            Update_Links
              (Canvas, Get_Window (Canvas.Drawing_Area), Canvas.Anim_GC, Item);

            if Canvas.Align_On_Grid then
               Item.Coord.X := X;
               Item.Coord.Y := Y;
            end if;
         end if;

         Selected := Selected.Next;
      end loop;

      return False;
   end Button_Motion;

   ------------
   -- Pixmap --
   ------------

   function Pixmap (Item : access Canvas_Item_Record'Class)
                   return Gdk.Pixmap.Gdk_Pixmap
   is
   begin
      return Item.Pixmap;
   end Pixmap;

   ------------------
   -- Item_Updated --
   ------------------

   procedure Item_Updated (Canvas : access Interactive_Canvas_Record;
                           Item   : access Canvas_Item_Record'Class)
   is
   begin
      if Item.Visible then
         Draw_Pixmap (Canvas.Double_Pixmap,
                      GC      => Canvas.Black_GC,
                      Src     => Pixmap (Item),
                      Xsrc    => 0,
                      Ysrc    => 0,
                      Xdest   => Item.Coord.X,
                      Ydest   => Item.Coord.Y);
         Queue_Draw_Area (Canvas.Drawing_Area,
                          Item.Coord.X, Item.Coord.Y,
                          Gint (Item.Coord.Width), Gint (Item.Coord.Height));
      end if;
   end Item_Updated;

   ------------------
   -- Item_Resized --
   ------------------

   procedure Item_Resized (Canvas : access Interactive_Canvas_Record;
                           Item   : access Canvas_Item_Record'Class)
   is
   begin
      Update_Adjustments (Canvas);
      Draw_On_Double_Buffer (Canvas);
   end Item_Resized;

   ------------
   -- Remove --
   ------------

   procedure Remove (Canvas : access Interactive_Canvas_Record;
                     Item   : access Canvas_Item_Record'Class)
   is
      Previous      : Canvas_Item_List := null;
      Current       : Canvas_Item_List := Canvas.Children;
      Previous_Link : Canvas_Link_List;
      Current_Link  : Canvas_Link_List;
   begin
      while Current /= null loop
         if Current.Item = Canvas_Item (Item) then

            --  Remove the item itself

            if Previous = null then
               Canvas.Children := Current.Next;
            else
               Previous.Next := Current.Next;
            end if;

            --  Remove all the links

            Previous_Link := null;
            Current_Link := Canvas.Links;
            while Current_Link /= null loop
               if Current_Link.Link.Src = Canvas_Item (Item)
                 or else Current_Link.Link.Dest = Canvas_Item (Item)
               then

                  if Previous_Link = null then
                     Canvas.Links := Current_Link.Next;
                  else
                     Previous_Link.Next := Current_Link.Next;
                  end if;

                  Destroy (Current_Link.Link);
                  Free (Current_Link);
               else
                  Previous_Link := Current_Link;
               end if;

               if Previous_Link /= null then
                  Current_Link := Previous_Link.Next;
               else
                  Current_Link := Canvas.Links;
               end if;
            end loop;

            --  Free the memory
            Free (Current);

            --  Have to redraw everything, since there might have been some
            --  links.
            Update_Adjustments (Canvas);
            Draw_On_Double_Buffer (Canvas);

            return;
         end if;
         Previous := Current;
         Current := Current.Next;
      end loop;
   end Remove;

   ---------------------
   -- On_Button_Click --
   ---------------------

   procedure On_Button_Click (Item   : access Canvas_Item_Record;
                              Event  : Gdk.Event.Gdk_Event_Button)
   is
   begin
      null;
   end On_Button_Click;

   ---------------
   -- Get_Coord --
   ---------------

   function Get_Coord (Item : access Canvas_Item_Record)
                      return Gdk.Rectangle.Gdk_Rectangle
   is
   begin
      return Item.Coord;
   end Get_Coord;

   --------------
   -- Has_Link --
   --------------

   function Has_Link (Canvas   : access Interactive_Canvas_Record;
                      From, To : access Canvas_Item_Record'Class;
                      Name     : String := "")
                     return Boolean
   is
      Current : Canvas_Link_List := Canvas.Links;
   begin
      while Current /= null loop
         if Current.Link.Src = Canvas_Item (From)
           and then Current.Link.Dest = Canvas_Item (To)
           and then (Name = ""
                     or else Current.Link.Descr.all = Name)
         then
            return True;
         end if;
         Current := Current.Next;
      end loop;
      return False;
   end Has_Link;

   ----------------
   -- Lower_Item --
   ----------------

   procedure Lower_Item (Canvas : access Interactive_Canvas_Record;
                         Item   : access Canvas_Item_Record'Class)
   is
      Previous     : Canvas_Item_List := Canvas.Children;
      Current      : Canvas_Item_List;
   begin
      --  Already on top?

      if Canvas.Children = null
        or else Canvas.Children.Item = Canvas_Item (Item)
      then
         return;
      end if;

      Current := Canvas.Children.Next;

      --  Look for the item.

      while Current /= null loop
         if Current.Item = Canvas_Item (Item) then

            Previous.Next := Current.Next;
            Current.Next := Canvas.Children;
            Canvas.Children := Current;
            exit;
         end if;
         Previous := Current;
         Current := Current.Next;
      end loop;

      Draw_On_Double_Buffer (Canvas);
   end Lower_Item;

   ----------------
   -- Raise_Item --
   ----------------

   procedure Raise_Item (Canvas : access Interactive_Canvas_Record;
                         Item   : access Canvas_Item_Record'Class)
   is
      Previous     : Canvas_Item_List := null;
      Current      : Canvas_Item_List := Canvas.Children;
      To_Move      : Canvas_Item_List := null;
   begin
      --  A single item => Nothing to do
      if Canvas.Children.Next = null then
         return;
      end if;

      while Current /= null loop
         if Current.Item = Canvas_Item (Item) then
            To_Move := Current;
            if Previous = null then
               Canvas.Children := Current.Next;
            else
               Previous.Next := Current.Next;
            end if;
         else
            Previous := Current;
         end if;

         Current := Current.Next;
      end loop;

      if Previous /= null and then To_Move /= null then
         Previous.Next := To_Move;
         To_Move.Next := null;
      end if;

      --  Have to redraw everything, since there might have been some
      --  links.
      Item_Updated (Canvas, Item);
   end Raise_Item;

   ---------------
   -- Is_On_Top --
   ---------------

   function Is_On_Top (Canvas : access Interactive_Canvas_Record;
                       Item   : access Canvas_Item_Record'Class)
                      return Boolean
   is
      Current      : Canvas_Item_List := Canvas.Children;
   begin
      if Current = null then
         return False;
      end if;

      while Current.Next /= null loop
         Current := Current.Next;
      end loop;
      return Current.Item = Canvas_Item (Item);
   end Is_On_Top;

   ---------------
   -- Show_Item --
   ---------------

   procedure Show_Item (Canvas : access Interactive_Canvas_Record;
                        Item   : access Canvas_Item_Record'Class)
   is
   begin
      Clamp_Page (Get_Hadjustment (Canvas),
                  Gfloat (Item.Coord.X),
                  Gfloat (Item.Coord.X) + Gfloat (Item.Coord.Width));
      Clamp_Page (Get_Vadjustment (Canvas),
                  Gfloat (Item.Coord.Y),
                  Gfloat (Item.Coord.Y) + Gfloat (Item.Coord.Height));
      Value_Changed (Get_Hadjustment (Canvas));
      Value_Changed (Get_Vadjustment (Canvas));
   end Show_Item;

   -----------------------
   -- Get_Align_On_Grid --
   -----------------------

   function Get_Align_On_Grid (Canvas : access Interactive_Canvas_Record)
                              return Boolean
   is
   begin
      return Canvas.Align_On_Grid;
   end Get_Align_On_Grid;

   --------------------
   -- Set_Visibility --
   --------------------

   procedure Set_Visibility
     (Item    : access Canvas_Item_Record;
      Visible : Boolean)
   is
   begin
      Item.Visible := Visible;
   end Set_Visibility;

   ----------------
   -- Is_Visible --
   ----------------

   function Is_Visible (Item : access Canvas_Item_Record) return Boolean is
   begin
      return Item.Visible;
   end Is_Visible;

   --------------------
   -- Refresh_Canvas --
   --------------------

   procedure Refresh_Canvas (Canvas : access Interactive_Canvas_Record) is
   begin
      Update_Adjustments (Canvas);
      Draw_On_Double_Buffer (Canvas);
   end Refresh_Canvas;

   ---------------------
   -- Clear_Selection --
   ---------------------

   procedure Clear_Selection (Canvas : access Interactive_Canvas_Record) is
      Tmp : Canvas_Item_List;
   begin
      while Canvas.Selection /= null loop
         Tmp := Canvas.Selection;
         Canvas.Selection := Canvas.Selection.Next;
         Free (Tmp);
      end loop;
   end Clear_Selection;

   ----------------------
   -- Add_To_Selection --
   ----------------------

   procedure Add_To_Selection
     (Canvas : access Interactive_Canvas_Record;
      Item : access Canvas_Item_Record'Class)
   is
      Tmp : Canvas_Item_List := Canvas.Selection;
   begin
      --  Is the item already in the selection ?
      while Tmp /= null loop
         if Tmp.Item = Canvas_Item (Item) then
            return;
         end if;
         Tmp := Tmp.Next;
      end loop;

      --  No => Add it
      Canvas.Selection := new Canvas_Item_List_Record'
        (Item => Canvas_Item (Item),
         Next => Canvas.Selection);
   end Add_To_Selection;

   ---------------------------
   -- Remove_From_Selection --
   ---------------------------

   procedure Remove_From_Selection
     (Canvas : access Interactive_Canvas_Record;
      Item : access Canvas_Item_Record'Class)
   is
      Tmp : Canvas_Item_List := Canvas.Selection;
      Previous : Canvas_Item_List := null;
   begin
      while Tmp /= null loop
         if Tmp.Item = Canvas_Item (Item) then
            if Previous = null then
               Canvas.Selection := Tmp.Next;
            else
               Previous.Next := Tmp.Next;
            end if;
            Free (Tmp);
            return;
         else
            Previous := Tmp;
            Tmp := Tmp.Next;
         end if;
      end loop;
   end Remove_From_Selection;

   ---------------
   -- Configure --
   ---------------

   procedure Configure
     (Link   : access Canvas_Link_Record;
      Src    : access Canvas_Item_Record'Class;
      Dest   : access Canvas_Item_Record'Class;
      Arrow  : in Arrow_Type := End_Arrow;
      Descr  : in String := "")
   is
   begin
      Link.Src := Canvas_Item (Src);
      Link.Dest := Canvas_Item (Dest);
      Link.Arrow := Arrow;

      Free (Link.Descr);
      Link.Descr := new String'(Descr);
   end Configure;

   --------------
   -- Add_Link --
   --------------

   procedure Add_Link
     (Canvas : access Interactive_Canvas_Record;
      Src    : access Canvas_Item_Record'Class;
      Dest   : access Canvas_Item_Record'Class;
      Arrow  : in Arrow_Type := End_Arrow;
      Descr  : in String := "";
      Side   : Link_Side := Automatic)
   is
      L : Canvas_Link;
   begin
      L := new Canvas_Link_Record;
      Configure (L, Src, Dest, Arrow, Descr);
      Add_Link (Canvas, L, Side);
   end Add_Link;

   --------------
   -- Has_Link --
   --------------

   function Has_Link
     (Canvas    : access Interactive_Canvas_Record'Class;
      Src, Dest : access Canvas_Item_Record'Class;
      Side      : Link_Side;
      Offset    : Gint) return Boolean
   is
      Current : Canvas_Link_List := Canvas.Links;
      Other_Side : Link_Side := Side;
   begin
      if Side = Left then
         Other_Side := Right;
      elsif Side = Right then
         Other_Side := Left;
      end if;

      while Current /= null loop
         if Current.Link.Src = Canvas_Item (Src)
           and then Current.Link.Dest = Canvas_Item (Dest)
           and then Current.Link.Side = Side
           and then Current.Link.Offset = Offset
         then
            return True;
         end if;

         if Current.Link.Src = Canvas_Item (Dest)
           and then Current.Link.Dest = Canvas_Item (Src)
           and then Current.Link.Side = Other_Side
           and then Current.Link.Offset = Offset
         then
            return True;
         end if;
         Current := Current.Next;
      end loop;
      return False;
   end Has_Link;

   --------------
   -- Add_Link --
   --------------

   procedure Add_Link
     (Canvas : access Interactive_Canvas_Record;
      Link   : access Canvas_Link_Record'Class;
      Side   : Link_Side := Automatic)
   is
      Offset    : Gint := 1;
      Auto_Side : Link_Side;
   begin
      --  Find the type of link that should be used.
      --  We can't use straight links for self referencing links.

      if Link.Src /= Link.Dest
        and then
        (Side = Straight
         or else
         (Side = Automatic
          and then not Has_Link (Canvas, Link.Src, Link.Dest, Straight, 0)))
      then
         Auto_Side := Straight;
         Offset := 0;
      else
         loop
            if Side /= Left and then
              not Has_Link (Canvas, Link.Src, Link.Dest, Right, Offset)
            then
               Auto_Side := Right;
               exit;
            elsif Side /= Right and then
              not Has_Link (Canvas, Link.Src, Link.Dest, Left, Offset)
            then
               Auto_Side := Left;
               exit;
            end if;
            Offset := Offset + 1;
         end loop;
      end if;

      Link.Side   := Auto_Side;
      Link.Offset := Offset;
      Canvas.Links := new Canvas_Link_List_Record'
        (Link => Canvas_Link (Link),
         Next => Canvas.Links);
   end Add_Link;

   -----------------
   -- Remove_Link --
   -----------------

   procedure Remove_Link
     (Canvas : access Interactive_Canvas_Record;
      Link   : access Canvas_Link_Record'Class)
   is
      Previous : Canvas_Link_List;
      Current : Canvas_Link_List := Canvas.Links;
   begin
      while Current /= null loop
         if Current.Link = Canvas_Link (Link) then
            if Previous = null then
               Canvas.Links := Current.Next;
            else
               Previous.Next := Current.Next;
            end if;
            Free (Current);
            return;
         end if;
         Previous := Current;
         Current := Current.Next;
      end loop;
   end Remove_Link;

   -------------------
   -- For_Each_Link --
   -------------------

   procedure For_Each_Link
     (Canvas  : access Interactive_Canvas_Record;
      Execute : Link_Processor)
   is
      Current : Canvas_Link_List := Canvas.Links;
      Tmp     : Canvas_Link_List;
   begin
      while Current /= null loop
         Tmp := Current.Next;
         exit when not Execute (Canvas, Current.Link);
         Current := Tmp;
      end loop;
   end For_Each_Link;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (Link : access Canvas_Link_Record) is
      L : Canvas_Link := Canvas_Link (Link);
   begin
      Free (Link.Descr);
      Free (L);
   end Destroy;

   -------------
   -- Get_Src --
   -------------

   function Get_Src (Link : access Canvas_Link_Record) return Canvas_Item is
   begin
      return Link.Src;
   end Get_Src;

   --------------
   -- Get_Dest --
   --------------

   function Get_Dest (Link : access Canvas_Link_Record) return Canvas_Item is
   begin
      return Link.Dest;
   end Get_Dest;

   ---------------
   -- Get_Descr --
   ---------------

   function Get_Descr (Link : access Canvas_Link_Record) return String is
   begin
      if Link.Descr = null then
         return "";
      else
         return Link.Descr.all;
      end if;
   end Get_Descr;

   -----------------
   -- Set_Src_Pos --
   -----------------

   procedure Set_Src_Pos
     (Link : access Canvas_Link_Record; X_Pos, Y_Pos : Gfloat := 0.5) is
   begin
      Link.Src_X_Pos := X_Pos;
      Link.Src_Y_Pos := Y_Pos;
   end Set_Src_Pos;

   ------------------
   -- Set_Dest_Pos --
   ------------------

   procedure Set_Dest_Pos
     (Link : access Canvas_Link_Record; X_Pos, Y_Pos : Gfloat := 0.5) is
   begin
      Link.Dest_X_Pos := X_Pos;
      Link.Dest_Y_Pos := Y_Pos;
   end Set_Dest_Pos;

end Gtkada.Canvas;
