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
--  The Gtk.Menu_Bar.Gtk_Menu_Bar is a subclass of
--  Gtk.Menu_Shell.Gtk_Menu_Shell which contains one or more Gtk_Menu_Items.
--  The result is a standard menu bar which can hold many menu items.
--
--  </description>

pragma Warnings (Off, "*is already use-visible*");
with Glib;           use Glib;
with Glib.Types;     use Glib.Types;
with Gtk.Buildable;  use Gtk.Buildable;
with Gtk.Enums;      use Gtk.Enums;
with Gtk.Menu_Shell; use Gtk.Menu_Shell;

package Gtk.Menu_Bar is

   type Gtk_Menu_Bar_Record is new Gtk_Menu_Shell_Record with null record;
   type Gtk_Menu_Bar is access all Gtk_Menu_Bar_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Menu_Bar : out Gtk_Menu_Bar);
   procedure Initialize
      (Menu_Bar : not null access Gtk_Menu_Bar_Record'Class);
   --  Creates a new Gtk.Menu_Bar.Gtk_Menu_Bar

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_menu_bar_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Child_Pack_Direction
      (Menu_Bar : not null access Gtk_Menu_Bar_Record)
       return Gtk.Enums.Gtk_Pack_Direction;
   --  Retrieves the current child pack direction of the menubar. See
   --  Gtk.Menu_Bar.Set_Child_Pack_Direction.
   --  Since: gtk+ 2.8

   procedure Set_Child_Pack_Direction
      (Menu_Bar       : not null access Gtk_Menu_Bar_Record;
       Child_Pack_Dir : Gtk.Enums.Gtk_Pack_Direction);
   --  Sets how widgets should be packed inside the children of a menubar.
   --  Since: gtk+ 2.8
   --  "child_pack_dir": a new Gtk.Enums.Gtk_Pack_Direction

   function Get_Pack_Direction
      (Menu_Bar : not null access Gtk_Menu_Bar_Record)
       return Gtk.Enums.Gtk_Pack_Direction;
   --  Retrieves the current pack direction of the menubar. See
   --  Gtk.Menu_Bar.Set_Pack_Direction.
   --  Since: gtk+ 2.8

   procedure Set_Pack_Direction
      (Menu_Bar : not null access Gtk_Menu_Bar_Record;
       Pack_Dir : Gtk.Enums.Gtk_Pack_Direction);
   --  Sets how items should be packed inside a menubar.
   --  Since: gtk+ 2.8
   --  "pack_dir": a new Gtk.Enums.Gtk_Pack_Direction

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------
   --  Methods inherited from the Buildable interface are not duplicated here
   --  since they are meant to be used by tools, mostly. If you need to call
   --  them, use an explicit cast through the "-" operator below.

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Buildable"

   package Implements_Gtk_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_Menu_Bar_Record, Gtk_Menu_Bar);
   function "+"
     (Widget : access Gtk_Menu_Bar_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Gtk_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_Menu_Bar
   renames Implements_Gtk_Buildable.To_Object;

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Child_Pack_Direction_Property
   --  Type: Gtk.Enums.Gtk_Pack_Direction
   --  Flags: read-write
   --  The child pack direction of the menubar. It determines how the widgets
   --  contained in child menuitems are arranged.
   --
   --  Name: Pack_Direction_Property
   --  Type: Gtk.Enums.Gtk_Pack_Direction
   --  Flags: read-write
   --  The pack direction of the menubar. It determines how menuitems are
   --  arranged in the menubar.

   Child_Pack_Direction_Property : constant Gtk.Enums.Property_Gtk_Pack_Direction;
   Pack_Direction_Property : constant Gtk.Enums.Property_Gtk_Pack_Direction;

private
   Pack_Direction_Property : constant Gtk.Enums.Property_Gtk_Pack_Direction :=
     Gtk.Enums.Build ("pack-direction");
   Child_Pack_Direction_Property : constant Gtk.Enums.Property_Gtk_Pack_Direction :=
     Gtk.Enums.Build ("child-pack-direction");
end Gtk.Menu_Bar;