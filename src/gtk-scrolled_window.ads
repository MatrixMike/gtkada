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
-- General Public License for more details.                          --
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

with Gtk.Adjustment;
with Gtk.Container;
with Gtk.Enums;
with Gtk.Widget;

package Gtk.Scrolled_Window is

   type Gtk_Scrolled_Window is new Container.Gtk_Container with private;

   procedure Gtk_New
     (Scrolled_Window :    out Gtk_Scrolled_Window;
      Hadjustment     : in     Adjustment.Gtk_Adjustment'Class :=
        Adjustment.Null_Adjustment;
      Vadjustment     : in     Adjustment.Gtk_Adjustment'Class :=
        Adjustment.Null_Adjustment);

   procedure Add_With_Viewport
     (Scrolled_Window : in out Gtk_Scrolled_Window;
      Child           : in     Gtk.Widget.Gtk_Widget'Class);

   function Get_Hadjustment (Scrolled_Window : in Gtk_Scrolled_Window)
                             return               Adjustment.Gtk_Adjustment;

   function Get_Vadjustment (Scrolled_Window : in Gtk_Scrolled_Window)
                             return               Adjustment.Gtk_Adjustment;

   procedure Set_Hadjustment
     (Scrolled_Window : in out Gtk_Scrolled_Window;
      Hadjustment     : in     Adjustment.Gtk_Adjustment'Class);
   procedure Set_Vadjustment
     (Scrolled_Window : in out Gtk_Scrolled_Window;
      Vadjustment     : in     Adjustment.Gtk_Adjustment'Class);
   procedure Set_Policy (Scrolled_Window    : in out Gtk_Scrolled_Window;
                         H_Scrollbar_Policy : in     Enums.Gtk_Policy_Type;
                         V_Scrollbar_Policy : in     Enums.Gtk_Policy_Type);

private
   type Gtk_Scrolled_Window is new Container.Gtk_Container with null record;

end Gtk.Scrolled_Window;
