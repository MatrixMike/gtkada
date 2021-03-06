------------------------------------------------------------------------------
--                  GtkAda - Ada95 binding for Gtk+/Gnome                   --
--                                                                          --
--                     Copyright (C) 2001-2018, AdaCore                     --
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
--  This package provides an interface to generic values as used in the
--  Glib object model.
--
--  The main type in this package is GValues, which is the
--  equivalent of the C's (GValue*) array, i.e an array of unions.  This
--  package provides functions to extract the values from this type.
--  </description>
--  <c_version>1.3.15</c_version>
--  <group>Glib, the general-purpose library</group>

with System;
with Interfaces.C.Strings;

with Glib.Object;

package Glib.Values is

   --  <doc_ignore>Do not create automatic documentation for this package

   type GValue is private;
   --  A generic value that can hold any of the types as provided in the
   --  Set and Get functions below.

   type GValues is private;
   --  This type represents a table of values. Each argument of the
   --  table can be of any type.
   --  The index of the first element is always 1.

   type C_GValues is new System.Address;
   --  An array of GValues

   type GValue_Array is array (Gint range <>) of GValue;

   function Make_Values (Nb : Guint) return GValues;
   --  Create a new GValues structure from scratch. This procedure
   --  causes the allocation of an underlying C array, and this memory
   --  should be deallocated after use using procedure Free (see below).

   function Make_Values (Nb : Guint; Val : C_GValues) return GValues;
   --  Build a GValues structure from the given C array. Nb should be the
   --  number of elements in the Values array.

   procedure Free (Val : in out GValues);
   --  Deallocate the memory associated with the given Values array.

   function Nth (Val : GValues; Num : Guint) return GValue;
   --  Return the Num-th element from Values.
   --  In general, the returned value does not need to be unset, since it is
   --  still handled by C (in particular when processing the parameters for a
   --  callback).

   --  <doc_ignore>

   procedure Unsafe_Nth (Values : C_GValues; Num : Guint; V : in out GValue);
   pragma Import (C, Unsafe_Nth, "ada_gvalue_nth");
   --  This returns the Num-th element, starting at 0. This procedure does
   --  not check that Values contains at least Num elements, so is potentially
   --  dangerous.
   --  In general, the returned value does not need to be unset, since it is
   --  still handled by C (in particular when processing the parameters for a
   --  callback).

   generic
      type T is private;
   function Unsafe_Proxy_Nth (Values : C_GValues; Num : Guint) return T;
   pragma Inline (Unsafe_Proxy_Nth);
   --  Extract a point from Values (at index Num, 0-based), and convert it to
   --  T. This is unsafe because no check is made that Num is a valid index,
   --  and no check is made that casting to T makes sense.

   generic
      type T is (<>);
   function Unsafe_Enum_Nth
     (Values : C_GValues; Num : Guint) return T;
   pragma Inline (Unsafe_Enum_Nth);
   --  Used for enumeration types

   --  </doc_ignore>

   -------------------------------------------------
   -- Conversion functions, interfacing to GValue --
   -------------------------------------------------

   procedure Init (Value : in out GValue; G_Type : Glib.GType);
   --  Set the type of Value to G_Type. This limits the operations you can then
   --  apply to Value. For instance, Value must have been initialized with
   --  a GType_Int before you can use Set_Int (see below).
   --  Note that for enumeration types, you shouldn't use GType_Enum, but
   --  rather the exact GType corresponding to the enumeration.
   --  If you need to store a reference-counted type in a GValue, it is
   --  recommanded that you use a type derived from Boxed (see Set_Boxed below)

   procedure Unset (Value : in out GValue);
   --  Frees the memory allocate for Value (like strings contents) in the call
   --  to Init. You only need to call this function in cases where you have
   --  called Init yourself.

   function Type_Of (Value : GValue) return Glib.GType;
   pragma Inline (Type_Of);
   --  Return the type of data that Value contains.
   --  It returns GType_Invalid if Value was not initialized

   procedure Set_Char (Value : in out GValue; V_Char : Gchar);
   function  Get_Char (Value : GValue) return Gchar;

   procedure Set_Uchar (Value : in out GValue; V_Uchar : Guchar);
   function  Get_Uchar (Value : GValue) return Guchar;

   procedure Init_Set_Boolean (Value : in out GValue; V : Boolean);
   procedure Set_Boolean (Value : in out GValue; V_Boolean : Boolean);
   function  Get_Boolean (Value : GValue) return Boolean;
   --  Set_Boolean must only be called when Init has already been used.
   --  Otherwise use Init_Set_Boolean.

   procedure Init_Set_Int (Value : in out GValue; V : Gint);
   procedure Set_Int (Value : in out GValue; V_Int : Gint);
   function  Get_Int (Value : GValue) return Gint;
   --  Set_Int must only be called when Init has already been used.
   --  Otherwise use Init_Set_Int.

   procedure Init_Set_Uint (Value : in out GValue; V : Guint);
   procedure Set_Uint (Value : in out GValue; V_Uint : Guint);
   function  Get_Uint (Value : GValue) return Guint;

   procedure Set_Long (Value : in out GValue; V_Long : Glong);
   function  Get_Long (Value : GValue) return Glong;

   procedure Set_Ulong (Value : in out GValue; V_Ulong : Gulong);
   function  Get_Ulong (Value : GValue) return Gulong;

   procedure Set_Float (Value : in out GValue; V_Float : Gfloat);
   function  Get_Float (Value : GValue) return Gfloat;

   procedure Set_Double (Value : in out GValue; V_Double : Gdouble);
   function  Get_Double (Value : GValue) return Gdouble;

   procedure Init_Set_String (Value : in out GValue; V : String);
   procedure Set_String (Value : in out GValue; V_String : String);
   function  Get_String (Value : GValue) return String;
   function  Get_String (Value : GValue; Length : Gint) return String;

   function  Get_Chars (Value : GValue) return Interfaces.C.Strings.chars_ptr;

   procedure Set_Proxy (Value : in out GValue; V_Proxy : C_Proxy);
   function  Get_Proxy (Value : GValue) return C_Proxy;

   procedure Set_Address (Value : in out GValue; V_Address : System.Address);
   function  Get_Address (Value : GValue) return System.Address;

   procedure Set_Boxed (Value : in out GValue; V_Address : System.Address);
   function  Get_Boxed (Value : GValue) return System.Address;
   --  This is similar to Set_Address and Get_Address, except that the boxed
   --  type might have been associated with some specific initialization and
   --  finalization functions through Glib.Boxed_Type_Register_Static
   --  For instance:
   --    declare
   --       Typ   : Glib.GType;
   --       Value : GValue;
   --       function To_Ref_Counted_Value is new Ada.Unchecked_Conversion
   --          (System.Address, My_Ref_Counted_Type);
   --    begin
   --       Typ := Boxed_Typed_Register_Static
   --          ("FOO", Copy'Access, Free'Access);
   --       Init (Value, Typ);
   --       Set_Boxed (Value, my_ref_counted_value.all'address);
   --
   --       Val := To_Ref_Counted_Value (Get_Boxed (Value));
   --       Unset (Value);
   --    end;
   --
   --  See also Glib.Generic_Properties.Generic_Internal_Boxed_Property.

   procedure Set_Enum (Value : in out GValue; V_Enum : Gint);
   function Get_Enum (Value : GValue) return Glib.Gint;
   --  These are used to manipulate the standard GtkAda enumeration types.
   --  For types that you have redefined yourself, you have access to more
   --  suitable functions directly in the package Generic_Enumeration_Property.

   procedure Set_Flags (Value : in out GValue; V_Enum : Guint);
   function Get_Flags (Value : GValue) return Glib.Guint;
   --  ??? Should really manipulate Glib.Properties.Creation.Flags_Int_Value

   procedure Set_Object
      (Value : in out GValue; To : access Glib.Object.GObject_Record'Class);
   function Get_Object (Value : GValue) return Glib.Object.GObject;
   --  These are used to manipulate GObject instances.

   --  Convenience function to Get and Set a Gtk_Text_Iter are
   --  also provided inside Gtk.Text_Iter.

   ----------------
   -- Parameters --
   ----------------
   --  When you create new widget types (see Glib.Object) you sometimes need
   --  to set properties immediately, since they can't be set after creation.

   type GParameter is record
      Name  : Interfaces.C.Strings.chars_ptr;
      Value : GValue;
   end record;
   type GParameter_Array is array (Natural range <>) of GParameter;

   procedure Free (Params : in out GParameter_Array);
   --  Free the memory used by Params

   procedure G_New
      (Object  : not null access Glib.Object.GObject_Record'Class;
       Typ     : GType;
       Params  : GParameter_Array);
   --  Allocate a new object and set properties.

private
   type GValue_Data is array (1 .. 2) of Guint64;
   type GValue is record
      g_type : GType := GType_Invalid;
      data   : GValue_Data;
   end record;
   pragma Convention (C, GValue);

   type GValues is record
      Nb  : Guint;
      Arr : C_GValues;
   end record;

   pragma Import (C, Set_Char, "g_value_set_char");
   pragma Import (C, Get_Char, "g_value_get_char");
   pragma Import (C, Set_Uchar, "g_value_set_uchar");
   pragma Import (C, Get_Uchar, "g_value_get_uchar");
   pragma Import (C, Set_Int, "g_value_set_int");
   pragma Import (C, Get_Int, "g_value_get_int");
   pragma Import (C, Set_Uint, "g_value_set_uint");
   pragma Import (C, Get_Uint, "g_value_get_uint");
   pragma Import (C, Set_Long, "g_value_set_long");
   pragma Import (C, Get_Long, "g_value_get_long");
   pragma Import (C, Set_Ulong, "g_value_set_ulong");
   pragma Import (C, Get_Ulong, "g_value_get_ulong");
   pragma Import (C, Set_Float, "g_value_set_float");
   pragma Import (C, Get_Float, "g_value_get_float");
   pragma Import (C, Set_Double, "g_value_set_double");
   pragma Import (C, Get_Double, "g_value_get_double");
   pragma Import (C, Set_Proxy, "g_value_set_pointer");
   pragma Import (C, Set_Address, "g_value_set_pointer");
   pragma Import (C, Set_Enum, "g_value_set_enum");
   pragma Import (C, Get_Enum, "g_value_get_enum");
   pragma Import (C, Get_Chars, "g_value_get_string");
   pragma Import (C, Set_Flags, "g_value_set_flags");
   pragma Import (C, Get_Flags, "g_value_get_flags");
   pragma Import (C, Set_Boxed, "g_value_set_boxed");
   pragma Import (C, Get_Boxed, "g_value_get_boxed");
   pragma Import (C, Unset, "g_value_unset");

   --  ??? We use our own version here, that doesn't check the type of
   --  GValue. This is used for signals (Gtk.Handlers), but should be
   --  cleaned up.
   pragma Import (C, Get_Address, "ada_gvalue_get_pointer");
   pragma Import (C, Get_Proxy, "ada_gvalue_get_pointer");

   pragma Inline (Make_Values);
   pragma Inline (Set_Boolean);
   pragma Inline (Get_Boolean);
   pragma Inline (Set_String);
   pragma Inline (Get_String);

   --  </doc_ignore>
end Glib.Values;
