with Gtk.Signal;

package body Gtk.Object is


   -----------------
   --  Connected  --
   -----------------

   function Connected (Object : in Gtk_Object'Class) return Boolean is
      function Internal (Object : in System.Address) return Guint32;
      pragma Import (C, Internal, "ada_object_connected");
   begin
      return To_Boolean (Internal (Get_Object (Object)));
   end Connected;


   -----------------
   -- Destroy --
   -----------------

   procedure Destroy (Object : in out Gtk_Object'Class)
   is
      procedure Internal  (Object : in System.Address);
      pragma Import (C, Internal, "gtk_object_destroy");
   begin
      --  When the widget is destroyed, the callbacks are automatically
      --  destroyed too.
      --  In this binding, we have to make sure the memory allocated for
      --  the data is freed. The simple way is to call
      Gtk.Signal.Handlers_Destroy (Object);

      Internal (Get_Object (Object));
      Set_Object (Object, System.Null_Address);
   end Destroy;


   ----------------
   --  Destroyed --
   ----------------

   function Destroyed (Object : in Gtk_Object'Class) return Boolean is
      function Internal (Object : in System.Address) return Guint32;
      pragma Import (C, Internal, "ada_object_destroyed");
   begin
      return To_Boolean (Internal (Get_Object (Object)));
   end Destroyed;


   -------------
   --  Flags  --
   -------------

   function Flags (Object : in Gtk_Object'Class) return Guint32 is
      function Internal (Object : in System.Address) return Guint32;
      pragma Import (C, Internal, "ada_object_flags");
   begin
      return Internal (Get_Object (Object));
   end Flags;


   ----------------
   --  Floating  --
   ----------------

   function Floating (Object : in Gtk_Object'Class) return Boolean is
      function Internal (Object : in System.Address) return Guint32;
      pragma Import (C, Internal, "ada_object_floating");
   begin
      return To_Boolean (Internal (Get_Object (Object)));
   end Floating;


   -----------------
   --  Set_Flags  --
   -----------------

   procedure Set_Flags (Object : in out Gtk_Object'Class;
                        Flags  : in     Guint32) is
      procedure Internal (Object : in System.Address;
                          Flags  : in Guint32);
      pragma Import (C, Internal, "ada_object_set_flags");
   begin
      Internal (Get_Object (Object), Flags);
   end Set_Flags;


   -------------------
   --  Unset_Flags  --
   -------------------

   procedure Unset_Flags (Object : in out Gtk_Object'Class;
                          Flags  : in     Guint32) is
      procedure Internal (Object : in System.Address;
                          Flags  : in Guint32);
      pragma Import (C, Internal, "ada_object_unset_flags");
   begin
      Internal (Get_Object (Object), Flags);
   end Unset_Flags;

end Gtk.Object;
