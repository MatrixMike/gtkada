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

with Gtk.Box;
with Gtk.Curve;

package Gtk.Gamma_Curve is

   type Gtk_Gamma_Curve is new Gtk.Box.Gtk_Box with private;

   procedure Gtk_New (Widget : out Gtk_Gamma_Curve);

   function Get_Curve (Widget : in Gtk_Gamma_Curve'Class)
                       return Gtk.Curve.Gtk_Curve;

   function Get_Gamma (Widget : in Gtk_Gamma_Curve'Class)
                       return Gfloat;

private

   type Gtk_Gamma_Curve is new Gtk.Box.Gtk_Box with null record;

   --  mapping: Gtk_New gtkgamma.h gtk_gamma_curve_new

   --  mapping: NOT_IMPLEMENTED gtkgamma.h gtk_gamma_curve_get_type

end Gtk.Gamma_Curve;
