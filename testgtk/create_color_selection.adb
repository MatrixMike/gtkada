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

with Gtk; use Gtk;
with Glib; use Glib;
with Gtk.Widget;
with Gtk.Color_Selection;        use Gtk.Color_Selection;
with Gtk.Color_Selection_Dialog; use Gtk.Color_Selection_Dialog;
with Gtk.Button;
with Gtk.Enums;
with Gtk.Signal;
with Gtk.Widget; use Gtk.Widget;
with Ada.Text_IO;
with Common; use Common;

package body Create_Color_Selection is

   package Color_Sel_Cb is new Signal.Object_Callback
     (Gtk_Color_Selection_Dialog);
   --  Must be instanciated at library level !

   procedure Color_Ok (Dialog : in out Gtk_Color_Selection_Dialog)
   is
      Color : Color_Array;
   begin
      Get_Color (Get_Colorsel (Dialog), Color);
      for I in Red .. Opacity loop
         Ada.Text_IO.Put_Line (Color_Index'Image (I)
                               & " => "
                               & Gdouble'Image (Color (I)));
      end loop;
      Set_Color (Get_Colorsel (Dialog), Color);
   end Color_Ok;

   Dialog : aliased Gtk_Color_Selection_Dialog;

   procedure Run
     (Widget : in out Button.Gtk_Button)
   is
      Cb_Id  : Guint;
   begin

      if not Is_Created (Dialog) then
         Gtk_New (Dialog, Title => "Color Selection Dialog");
         Set_Opacity (Get_Colorsel (Dialog), True);
         Set_Update_Policy (Get_Colorsel (Dialog), Enums.Update_Continuous);
         Set_Position (Dialog, Enums.Win_Pos_Mouse);

         Cb_Id := Widget2_Cb.Connect (Dialog,
                                      "destroy",
                                      Destroyed'Access,
                                      Dialog'Access);

         Cb_Id := Color_Sel_Cb.Connect (Get_OK_Button (Dialog),
                                        "clicked",
                                        Color_Ok'Access,
                                        Dialog);
         Cb_Id := Widget_Cb.Connect (Get_Cancel_Button (Dialog),
                                   "clicked",
                                   Gtk.Widget.Destroy'Access,
                                   Dialog);
      end if;

      if not Gtk.Widget.Visible_Is_Set (Dialog) then
         Show (Dialog);
      else
         Destroy (Dialog);
      end if;
   end Run;

end Create_Color_Selection;

