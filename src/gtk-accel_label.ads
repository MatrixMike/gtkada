-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-2000                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
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

with Gtk.Label;
with Gtk.Widget;
with Gtk.Object;

package Gtk.Accel_Label is

   type Gtk_Accel_Label_Record is new Gtk.Label.Gtk_Label_Record with private;
   type Gtk_Accel_Label is access all Gtk_Accel_Label_Record;

   procedure Gtk_New (Accel_Label : out Gtk_Accel_Label; Str : in  String);
   procedure Initialize
     (Accel_Label : access Gtk_Accel_Label_Record'Class;
      Str         : in String);

   function Get_Accel_Width (Accel_Label : access Gtk_Accel_Label_Record)
     return Guint;

   procedure Set_Accel_Widget
     (Accel_Label  : access Gtk_Accel_Label_Record;
      Accel_Widget : access Gtk.Widget.Gtk_Widget_Record'Class);

   function Refetch (Accel_Label : access Gtk_Accel_Label_Record)
     return Boolean;

   procedure Generate (N : in Node_Ptr; File : in File_Type);
   --  Gate internal function

   procedure Generate
     (Accel_Label : in out Gtk.Object.Gtk_Object; N : in Node_Ptr);
   --  Dgate internal function

private

   type Gtk_Accel_Label_Record is new Gtk.Label.Gtk_Label_Record
     with null record;

end Gtk.Accel_Label;
