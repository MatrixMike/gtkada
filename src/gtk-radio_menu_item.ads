-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
-- Copyright (C) 1998 Emmanuel Briot and Joel Brobecker              --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- Library General Public License for more details.                  --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with Gtk.Check_Menu_Item;
with Gtk.Enums; use Gtk.Enums;

package Gtk.Radio_Menu_Item is

   type Gtk_Radio_Menu_Item is new Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
     with private;

   function Group (Radio_Menu_Item : in Gtk_Radio_Menu_Item'Class)
                   return               Widget_SList.GSlist;
   procedure Gtk_New
      (Widget : out Gtk_Radio_Menu_Item;
       Group  : in Widget_SList.GSlist;
       Label  : in String);
   procedure Gtk_New (Widget : out Gtk_Radio_Menu_Item;
                      Group  : in Widget_SList.GSlist);
   procedure Set_Group
      (Radio_Menu_Item : in Gtk_Radio_Menu_Item'Class;
       Group           : in Widget_SList.GSlist);

private
   type Gtk_Radio_Menu_Item is new Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
     with null record;

   --  mapping: NOT_IMPLEMENTED gtkradiomenuitem.h gtk_radio_menu_item_get_type
   --  mapping: Group gtkradiomenuitem.h gtk_radio_menu_item_group
   --  mapping: Gtk_New gtkradiomenuitem.h gtk_radio_menu_item_new_with_label
   --  mapping: Gtk_New gtkradiomenuitem.h gtk_radio_menu_item_new
   --  mapping: Set_Group gtkradiomenuitem.h gtk_radio_menu_item_set_group
end Gtk.Radio_Menu_Item;
