package body Gtk is

   ----------------
   -- Get_Object --
   ----------------

   function Get_Object (Object : in Root_Type'Class)
                        return System.Address is
   begin
      return Object.Ptr;
   end Get_Object;


   ---------------------
   --  Major_Version  --
   ---------------------

   function Major_Version return Guint is
      Number : Guint;
      pragma Import (C, Number, "gtk_major_version");
   begin
      return Number;
   end Major_Version;


   ---------------------
   --  Micro_Version  --
   ---------------------

   function Micro_Version return Guint is
      Number : Guint;
      pragma Import (C, Number, "gtk_micro_version");
   begin
      return Number;
   end Micro_Version;

   ---------------------
   --  Minor_Version  --
   ---------------------

   function Minor_Version return Guint is
      Number : Guint;
      pragma Import (C, Number, "gtk_minor_version");
   begin
      return Number;
   end Minor_Version;


   ----------------
   -- Set_Object --
   ----------------

   procedure Set_Object (Object : in out Root_Type'Class;
                         Value  : in     System.Address) is
      use type System.Address;
   begin
      Object.Ptr := Value;
   end Set_Object;


   ------------------
   --  To_Boolean  --
   ------------------

   function To_Boolean (Value : in Gint) return Boolean is
   begin
      return Value /= 0;
   end To_Boolean;


   ---------------
   --  To_Gint  --
   ---------------

   function To_Gint (Bool : in Boolean) return Gint is
   begin
      if Bool then
         return 1;
      else
         return 0;
      end if;
   end To_Gint;

end Gtk;
