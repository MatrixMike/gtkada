------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  <description>
--  A GtkScale is a slider control used to select a numeric value. To use it,
--  you'll probably want to investigate the methods on its base class,
--  Gtk.GRange.Gtk_Range, in addition to the methods for GtkScale itself. To
--  set the value of a scale, you would normally use Gtk.GRange.Set_Value. To
--  detect changes to the value, you would normally use the
--  Gtk.GRange.Gtk_Range::value-changed signal.
--
--  Note that using the same upper and lower bounds for the
--  Gtk.Scale.Gtk_Scale (through the Gtk.GRange.Gtk_Range methods) will hide
--  the slider itself. This is useful for applications that want to show an
--  undeterminate value on the scale, without changing the layout of the
--  application (such as movie or music players).
--
--  == GtkScale as GtkBuildable ==
--
--  GtkScale supports a custom &lt;marks&gt; element, which can contain
--  multiple &lt;mark&gt; elements. The "value" and "position" attributes have
--  the same meaning as Gtk.Scale.Add_Mark parameters of the same name. If the
--  element is not empty, its content is taken as the markup to show at the
--  mark. It can be translated with the usual "translatable and "context"
--  attributes.
--
--  </description>
--  <screenshot>gtk-scale.png</screenshot>
--  <group>Numeric/Text Data Entry</group>

pragma Warnings (Off, "*is already use-visible*");
with Glib;            use Glib;
with Glib.Properties; use Glib.Properties;
with Glib.Types;      use Glib.Types;
with Gtk.Adjustment;  use Gtk.Adjustment;
with Gtk.Buildable;   use Gtk.Buildable;
with Gtk.Enums;       use Gtk.Enums;
with Gtk.GRange;      use Gtk.GRange;
with Gtk.Orientable;  use Gtk.Orientable;
with Gtk.Widget;      use Gtk.Widget;
with Pango.Layout;    use Pango.Layout;

package Gtk.Scale is

   type Gtk_Scale_Record is new Gtk_Range_Record with null record;
   type Gtk_Scale is access all Gtk_Scale_Record'Class;

   subtype Gtk_Hscale_Record is Gtk_Scale_Record;
   subtype Gtk_Hscale is Gtk_Scale;

   subtype Gtk_Vscale_Record is Gtk_Scale_Record;
   subtype Gtk_Vscale is Gtk_Scale;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New
      (Scale       : out Gtk_Scale;
       Orientation : Gtk.Enums.Gtk_Orientation;
       Adjustment  : access Gtk.Adjustment.Gtk_Adjustment_Record'Class);
   procedure Initialize
      (Scale       : access Gtk_Scale_Record'Class;
       Orientation : Gtk.Enums.Gtk_Orientation;
       Adjustment  : access Gtk.Adjustment.Gtk_Adjustment_Record'Class);
   --  Creates a new Gtk.Scale.Gtk_Scale.
   --  Since: gtk+ 3.0
   --  "orientation": the scale's orientation.
   --  "adjustment": the Gtk.Adjustment.Gtk_Adjustment which sets the range of
   --  the scale, or null to create a new adjustment.

   procedure Gtk_New_With_Range
      (Scale       : out Gtk_Scale;
       Orientation : Gtk.Enums.Gtk_Orientation;
       Min         : Gdouble;
       Max         : Gdouble;
       Step        : Gdouble);
   procedure Initialize_With_Range
      (Scale       : access Gtk_Scale_Record'Class;
       Orientation : Gtk.Enums.Gtk_Orientation;
       Min         : Gdouble;
       Max         : Gdouble;
       Step        : Gdouble);
   --  Creates a new scale widget with the given orientation that lets the
   --  user input a number between Min and Max (including Min and Max) with the
   --  increment Step. Step must be nonzero; it's the distance the slider moves
   --  when using the arrow keys to adjust the scale value.
   --  Note that the way in which the precision is derived works best if Step
   --  is a power of ten. If the resulting precision is not suitable for your
   --  needs, use Gtk.Scale.Set_Digits to correct it.
   --  Since: gtk+ 3.0
   --  "orientation": the scale's orientation.
   --  "min": minimum value
   --  "max": maximum value
   --  "step": step increment (tick size) used with keyboard shortcuts

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_scale_get_type");

   procedure Gtk_New_Hscale
      (Scale      : out Gtk_Hscale;
       Adjustment : Gtk.Adjustment.Gtk_Adjustment := null);
   procedure Initialize_Hscale
      (Scale      : access Gtk_Hscale_Record'Class;
       Adjustment : Gtk.Adjustment.Gtk_Adjustment := null);
   procedure Gtk_New_Hscale
      (Scale : out Gtk_Hscale;
       Min   : Gdouble;
       Max   : Gdouble;
       Step  : Gdouble);
   procedure Initialize_Hscale
      (Scale : access Gtk_Hscale_Record'Class;
       Min   : Gdouble;
       Max   : Gdouble;
       Step  : Gdouble);
   --  Creates a new horizontal scale widget that lets the user input a number
   --  between Min and Max (including Min and Max) with the increment Step.
   --  Step must be nonzero; it's the distance the slider moves when using the
   --  arrow keys to adjust the scale value.
   --  Note that the way in which the precision is derived works best if Step
   --  is a power of ten. If the resulting precision is not suitable for your
   --  needs, use Gtk.Scale.Set_Digits to correct it.
   --  "min": minimum value
   --  "max": maximum value
   --  "step": step increment (tick size) used with keyboard shortcuts

   function Hscale_Get_Type return Glib.GType;
   pragma Import (C, Hscale_Get_Type, "gtk_hscale_get_type");

   procedure Gtk_New_Vscale
      (Scale      : out Gtk_Vscale;
       Adjustment : Gtk.Adjustment.Gtk_Adjustment := null);
   procedure Initialize_Vscale
      (Scale      : access Gtk_Vscale_Record'Class;
       Adjustment : Gtk.Adjustment.Gtk_Adjustment := null);
   procedure Gtk_New_Vscale
      (Scale : out Gtk_Vscale;
       Min   : Gdouble;
       Max   : Gdouble;
       Step  : Gdouble);
   procedure Initialize_Vscale
      (Scale : access Gtk_Vscale_Record'Class;
       Min   : Gdouble;
       Max   : Gdouble;
       Step  : Gdouble);
   --  Creates a new vertical scale widget that lets the user input a number
   --  between Min and Max (including Min and Max) with the increment Step.
   --  Step must be nonzero; it's the distance the slider moves when using the
   --  arrow keys to adjust the scale value.
   --  Note that the way in which the precision is derived works best if Step
   --  is a power of ten. If the resulting precision is not suitable for your
   --  needs, use Gtk.Scale.Set_Digits to correct it.
   --  "min": minimum value
   --  "max": maximum value
   --  "step": step increment (tick size) used with keyboard shortcuts

   function Vscale_Get_Type return Glib.GType;
   pragma Import (C, Vscale_Get_Type, "gtk_vscale_get_type");

   -------------
   -- Methods --
   -------------

   procedure Add_Mark
      (Scale    : access Gtk_Scale_Record;
       Value    : Gdouble;
       Position : Gtk.Enums.Gtk_Position_Type;
       Markup   : UTF8_String);
   --  Adds a mark at Value.
   --  A mark is indicated visually by drawing a tick mark next to the scale,
   --  and GTK+ makes it easy for the user to position the scale exactly at the
   --  marks value.
   --  If Markup is not null, text is shown next to the tick mark.
   --  To remove marks from a scale, use Gtk.Scale.Clear_Marks.
   --  Since: gtk+ 2.16
   --  "value": the value at which the mark is placed, must be between the
   --  lower and upper limits of the scales' adjustment
   --  "position": where to draw the mark. For a horizontal scale, GTK_POS_TOP
   --  and %GTK_POS_LEFT are drawn above the scale, anything else below. For a
   --  vertical scale, GTK_POS_LEFT and %GTK_POS_TOP are drawn to the left of
   --  the scale, anything else to the right.
   --  "markup": Text to be shown at the mark, using <link
   --  linkend="PangoMarkupFormat">Pango markup</link>, or null

   procedure Clear_Marks (Scale : access Gtk_Scale_Record);
   --  Removes any marks that have been added with Gtk.Scale.Add_Mark.
   --  Since: gtk+ 2.16

   function Get_Digits (Scale : access Gtk_Scale_Record) return Gint;
   procedure Set_Digits
      (Scale            : access Gtk_Scale_Record;
       Number_Of_Digits : Gint);
   --  Sets the number of decimal places that are displayed in the value. Also
   --  causes the value of the adjustment to be rounded off to this number of
   --  digits, so the retrieved value matches the value the user saw.
   --  "digits": the number of decimal places to display, e.g. use 1 to
   --  display 1.0, 2 to display 1.00, etc

   function Get_Draw_Value (Scale : access Gtk_Scale_Record) return Boolean;
   procedure Set_Draw_Value
      (Scale      : access Gtk_Scale_Record;
       Draw_Value : Boolean);
   --  Specifies whether the current value is displayed as a string next to
   --  the slider.
   --  "draw_value": True to draw the value

   function Get_Layout
      (Scale : access Gtk_Scale_Record) return Pango.Layout.Pango_Layout;
   --  Gets the Pango.Layout.Pango_Layout used to display the scale. The
   --  returned object is owned by the scale so does not need to be freed by
   --  the caller.
   --  or null if the Gtk.Scale.Gtk_Scale:draw-value property is False.
   --  Since: gtk+ 2.4

   procedure Get_Layout_Offsets
      (Scale : access Gtk_Scale_Record;
       X     : out Gint;
       Y     : out Gint);
   --  Obtains the coordinates where the scale will draw the
   --  Pango.Layout.Pango_Layout representing the text in the scale. Remember
   --  when using the Pango.Layout.Pango_Layout function you need to convert to
   --  and from pixels using PANGO_PIXELS or PANGO_SCALE.
   --  If the Gtk.Scale.Gtk_Scale:draw-value property is False, the return
   --  values are undefined.
   --  Since: gtk+ 2.4
   --  "x": location to store X offset of layout, or null
   --  "y": location to store Y offset of layout, or null

   function Get_Value_Pos
      (Scale : access Gtk_Scale_Record) return Gtk.Enums.Gtk_Position_Type;
   procedure Set_Value_Pos
      (Scale : access Gtk_Scale_Record;
       Pos   : Gtk.Enums.Gtk_Position_Type);
   --  Sets the position in which the current value is displayed.
   --  "pos": the position in which the current value is displayed

   ---------------------
   -- Interfaces_Impl --
   ---------------------

   function Get_Orientation
      (Self : access Gtk_Scale_Record) return Gtk.Enums.Gtk_Orientation;
   procedure Set_Orientation
      (Self        : access Gtk_Scale_Record;
       Orientation : Gtk.Enums.Gtk_Orientation);

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Buildable"
   --
   --  - "Orientable"

   package Implements_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_Scale_Record, Gtk_Scale);
   function "+"
     (Widget : access Gtk_Scale_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_Scale
   renames Implements_Buildable.To_Object;

   package Implements_Orientable is new Glib.Types.Implements
     (Gtk.Orientable.Gtk_Orientable, Gtk_Scale_Record, Gtk_Scale);
   function "+"
     (Widget : access Gtk_Scale_Record'Class)
   return Gtk.Orientable.Gtk_Orientable
   renames Implements_Orientable.To_Interface;
   function "-"
     (Interf : Gtk.Orientable.Gtk_Orientable)
   return Gtk_Scale
   renames Implements_Orientable.To_Object;

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Number_Of_Digits_Property
   --  Type: Gint
   --  Flags: read-write
   --
   --  Name: Draw_Value_Property
   --  Type: Boolean
   --  Flags: read-write
   --
   --  Name: Value_Pos_Property
   --  Type: Gtk.Enums.Gtk_Position_Type
   --  Flags: read-write
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)

   Number_Of_Digits_Property : constant Glib.Properties.Property_Int;
   Draw_Value_Property : constant Glib.Properties.Property_Boolean;
   Value_Pos_Property : constant Gtk.Enums.Property_Gtk_Position_Type;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "format-value"
   --     function Handler
   --       (Self  : access Gtk_Scale_Record'Class;
   --        Value : Gdouble) return UTF8_String;
   --    --  "value": the value to format
   --  Signal which allows you to change how the scale value is displayed.
   --  Connect a signal handler which returns an allocated string representing
   --  Value. That string will then be used to display the scale's value.
   --  Here's an example signal handler which displays a value 1.0 as with
   --  "--&gt;1.0&lt;--". |[ static gchar* format_value_callback (GtkScale
   --  *scale, gdouble value) { return g_strdup_printf
   --  ("--&gt;&percnt;0.*g&lt;--", gtk_scale_get_digits (scale), value); } ]|
   --  Returns allocated string representing Value

   Signal_Format_Value : constant Glib.Signal_Name := "format-value";

private
   Number_Of_Digits_Property : constant Glib.Properties.Property_Int :=
     Glib.Properties.Build ("digits");
   Draw_Value_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("draw-value");
   Value_Pos_Property : constant Gtk.Enums.Property_Gtk_Position_Type :=
     Gtk.Enums.Build ("value-pos");
end Gtk.Scale;
