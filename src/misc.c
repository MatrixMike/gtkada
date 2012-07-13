/*
-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2012, AdaCore                   --
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
*/

#include "config.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <glib.h>
#include <glib-object.h>

#include <pango/pango.h>

#include <gdk/gdk.h>
#include <gtk/gtk.h>

gint
convert_a (gpointer a)
{
   return GPOINTER_TO_INT (a);
}

gpointer
convert_i (gint s)
{
   return GINT_TO_POINTER (s);
}

guint
convert_ua (gpointer a)
{
   return GPOINTER_TO_UINT (a);
}

gpointer
convert_ui (guint s)
{
   return GUINT_TO_POINTER (s);
}

/********************************************************************
 *  Returns the major/minor/macro version number of Gtk+. This is
 *  needed as the windows version uses a different convention for the
 *  corresponding variables gtk_{major/minor/micro)_version than the
 *  unix version.
 ********************************************************************/

guint
ada_gtk_major_version ()
{
  return GTK_MAJOR_VERSION;
}

guint
ada_gtk_minor_version ()
{
  return GTK_MINOR_VERSION;
}

guint
ada_gtk_micro_version ()
{
  return GTK_MICRO_VERSION;
}

/********************************************************************
 **  var_arg wrappers.
 ********************************************************************/

gpointer
ada_g_object_new (GType object_type)
{
  return g_object_new (object_type, NULL);
}

void
ada_g_object_get_ulong (gpointer object,
		        const gchar *property_name,
		        gulong *property)
{
  g_object_get (object, property_name, property, NULL);
}


void
ada_g_object_set_string (gpointer object,
			 const gchar *property_name,
			 const gchar *property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_object_set_int (gpointer object,
		      const gchar *property_name,
		      gint property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_object_set_ulong (gpointer object,
		        const gchar *property_name,
		        gulong property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_object_set_ptr (gpointer object,
		      const gchar *property_name,
		      void *property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_object_set_float (gpointer object,
			const gchar *property_name,
			gfloat property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_object_set_double (gpointer object,
			 const gchar *property_name,
			 gdouble property)
{
  g_object_set (object, property_name, property, NULL);
}

void
ada_g_signal_emit_by_name (gpointer     instance,
			   const gchar *detailed_signal)
{
  g_signal_emit_by_name (instance, detailed_signal);
}

void
ada_g_signal_emit_by_name_ptr (gpointer     instance,
			       const gchar *detailed_signal,
			       void *arg)
{
  g_signal_emit_by_name (instance, detailed_signal, arg);
}

void
ada_g_signal_emit_by_name_ptr_ptr (gpointer     instance,
			           const gchar *detailed_signal,
			           void *arg1,
			           void *arg2)
{
  g_signal_emit_by_name (instance, detailed_signal, arg1, arg2);
}

void
ada_g_signal_emit_by_name_int_int (gpointer     instance,
			           const gchar *detailed_signal,
			           gint arg1,
			           gint arg2)
{
  g_signal_emit_by_name (instance, detailed_signal, arg1, arg2);
}

void
ada_g_signal_emit_by_name_int_ptr (gpointer     instance,
			           const gchar *detailed_signal,
			           gint arg1,
			           void *arg2)
{
  g_signal_emit_by_name (instance, detailed_signal, arg1, arg2);
}

void
ada_gtk_list_store_set_ptr (GtkListStore *list_store,
                            GtkTreeIter  *iter,
                            gint          col,
                            void         *val)
{
  gtk_list_store_set (list_store, iter, col, val, -1);
}


void
ada_gtk_list_store_set_int (GtkListStore *list_store,
                            GtkTreeIter  *iter,
                            gint          col,
                            gint          val)
{
  gtk_list_store_set (list_store, iter, col, val, -1);
}

void
ada_gtk_list_store_set_boolean (GtkListStore *list_store,
                            GtkTreeIter  *iter,
                            gint          col,
                            gboolean          val)
{
  gtk_list_store_set (list_store, iter, col, val, -1);
}

void
ada_gtk_list_store_set_pixbuf (GtkListStore *list_store,
                            GtkTreeIter  *iter,
                            gint          col,
                            GdkPixbuf*    val)
{
  gtk_list_store_set (list_store, iter, col, val, -1);
}

void
ada_gtk_tree_store_set_ptr (GtkTreeStore *tree_store,
			    GtkTreeIter  *iter,
			    gint          col,
			    void         *val)
{
  gtk_tree_store_set (tree_store, iter, col, val, -1);
}

void
ada_gtk_tree_store_set_int (GtkTreeStore *tree_store,
			    GtkTreeIter  *iter,
			    gint          col,
			    gint          val)
{
  gtk_tree_store_set (tree_store, iter, col, val, -1);
}

void
ada_gtk_tree_store_set_ptr_ptr (GtkTreeStore *tree_store,
			        GtkTreeIter  *iter,
			        gint          col1,
			        void         *val1,
			        gint          col2,
			        void         *val2)
{
  gtk_tree_store_set (tree_store, iter, col1, val1, col2, val2, -1);
}

void
ada_gtk_tree_store_set_ptr_int (GtkTreeStore *tree_store,
			        GtkTreeIter  *iter,
			        gint          col1,
			        void         *val1,
			        gint          col2,
			        gint          val2)
{
  gtk_tree_store_set (tree_store, iter, col1, val1, col2, val2, -1);
}

void
ada_gtk_tree_store_set_int_int_int (GtkTreeStore *tree_store,
			            GtkTreeIter  *iter,
			            gint          col1,
			            gint          val1,
			            gint          col2,
			            gint          val2,
			            gint          col3,
			            gint          val3)
{
  gtk_tree_store_set
    (tree_store, iter, col1, val1, col2, val2, col3, val3, -1);
}

void
ada_gtk_tree_store_set_ptr_int_int (GtkTreeStore *tree_store,
			            GtkTreeIter  *iter,
			            gint          col1,
			            void         *val1,
			            gint          col2,
			            gint          val2,
			            gint          col3,
			            gint          val3)
{
  gtk_tree_store_set
    (tree_store, iter, col1, val1, col2, val2, col3, val3, -1);
}

void
ada_gtk_tree_store_set_ptr_int_ptr (GtkTreeStore *tree_store,
			            GtkTreeIter  *iter,
			            gint          col1,
			            void         *val1,
			            gint          col2,
			            gint          val2,
			            gint          col3,
			            void         *val3)
{
  gtk_tree_store_set
    (tree_store, iter, col1, val1, col2, val2, col3, val3, -1);
}

void
ada_gtk_tree_store_set_ptr_ptr_int (GtkTreeStore *tree_store,
			            GtkTreeIter  *iter,
			            gint          col1,
			            void         *val1,
			            gint          col2,
			            void         *val2,
			            gint          col3,
			            gint          val3)
{
  gtk_tree_store_set
    (tree_store, iter, col1, val1, col2, val2, col3, val3, -1);
}

void
ada_gtk_tree_store_set_int_ptr_int (GtkTreeStore *tree_store,
			            GtkTreeIter  *iter,
			            gint          col1,
			            void         *val1,
			            void         *col2,
			            void         *val2,
			            gint          col3,
			            gint          val3)
{
  gtk_tree_store_set
    (tree_store, iter, col1, val1, col2, val2, col3, val3, -1);
}

void
ada_gtk_tree_model_get_int (GtkTreeModel *tree_model,
			    GtkTreeIter  *iter,
			    gint          column,
			    gint         *value)
{
  gtk_tree_model_get (tree_model, iter, column, value, -1);
}

void
ada_gtk_tree_model_get_ptr (GtkTreeModel *tree_model,
			    GtkTreeIter  *iter,
			    gint          column,
			    void         *value)
{
  gtk_tree_model_get (tree_model, iter, column, value, -1);
}

GtkWidget*
ada_gtk_dialog_new_with_buttons (const gchar     *title,
                                 GtkWindow       *parent,
                                 GtkDialogFlags   flags)
{
  return gtk_dialog_new_with_buttons (title, parent, flags,
                                      NULL /* first_button_text*/, NULL);
}

GtkWidget*
ada_gtk_widget_new (GType type)
{
  return gtk_widget_new (type, NULL);
}

void
ada_gtk_widget_style_get_int (GtkWidget   *widget,
			      const gchar *first_property_name,
			      gint        *value)
{
  gtk_widget_style_get (widget, first_property_name, value, NULL);
}

gboolean
ada_gdk_pixbuf_save (GdkPixbuf  *pixbuf,
		     const char *filename,
		     const char *type,
		     GError    **error,
		     char       *key,
		     char       *value)
{
  return gdk_pixbuf_save (pixbuf, filename, type, error, key, value, NULL);
}

void
ada_g_log (const gchar    *log_domain,
	   GLogLevelFlags  log_level,
	   const gchar    *format)
{
  g_log (log_domain, log_level, format);
}

void
c_sprintf (char *s, char *format, int arg1, int arg2, int arg3)
{
  sprintf (s, format, arg1, arg2, arg3);
}

/********************************************************************
 **  This function should only be used for debug purposes.
 ********************************************************************/

guint
ada_gtk_debug_get_ref_count (GObject* object) {
  return G_OBJECT (object)->ref_count;
}

/********************************************************************
 **  This function parses the command line and returns
 **  true if macro_switch exists. It is also removed from
 **  the command line
 ********************************************************************/

int
ada_gtk_parse_cmd_line (int *gnat_argc, char **gnat_argv, char* macro_switch)
{
  int i;

  for (i=1; i<*gnat_argc; i++)
    {
      if (! strcmp (gnat_argv[i], macro_switch)) {
	while (i < * gnat_argc - 1) {
	  gnat_argv [i] = gnat_argv [i + 1];
	  i++;
	}
	gnat_argv [i] = NULL;
	(*gnat_argc)--;
	return 1;
      }
    }
  return 0;
}

/******************************************
 ** GSignal                              **
 ******************************************/

const gchar*
ada_gsignal_query_signal_name (GSignalQuery* query)
{
  return query->signal_name;
}

const GType*
ada_gsignal_query_params (GSignalQuery* query, guint* n_params)
{
  *n_params = query->n_params;
  return query->param_types;
}

guint
ada_gsignal_query_id (GSignalQuery* query)
{
  return query->signal_id;
}

GType
ada_gsignal_query_return_type (GSignalQuery* query)
{
  return query->return_type;
}

/*********************************************************************
 ** Creating new widgets
 ** For each new widget created by the user, we create a new
 ** class record, that has the following layout:
 **
 **  struct NewClassRecord {
 **     struct AncestorClass ancestor_class;   // the ancestor
 **     void (*handler1) (...);                // handler for first signal
 **     void (*handler2) (...);                // handler for second signal
 **     ...
 **     void (*handlern) (...);                // handler for nth signal
 **     VirtualFunctions * virtual;            // pointer to virtual interface
 **                                            // functions
 **     GObjectGetPropertyFunc real_get_property;
 **                                            // pointer to the get_property
 **                                            // in user's code
 **     GObjectSetPropertyFunc real_set_property;
 **                                            // likewise for set_property
 **  };
 **
 ** struct VirtualFunctions {
 **     void (*virtual) (...);                 // first virtual function for
 **                                            // interfaces
 **     ...
 **     void (*virtual) (...);
 ** }

 *********************************************************************/

GType
ada_type_from_class (gpointer klass)
{
  return G_TYPE_FROM_CLASS (klass);
}

void *
ada_get_nth_virtual_function (GObjectClass* class, gint num)
{
  GTypeQuery query;
  gpointer * virtual_functions;

  g_type_query (G_TYPE_FROM_CLASS (class), &query);
  virtual_functions = (gpointer*)((char*)(class)
				  + query.class_size
				  - sizeof (GObjectGetPropertyFunc)
				  - sizeof (GObjectSetPropertyFunc)
				  - sizeof (gpointer));
  return virtual_functions + num * sizeof (gpointer);
}

void
ada_gtk_set_draw_handler
   (GObjectClass* klass, 
    gboolean (*draw) (GtkWidget *, cairo_t*))
{

  if (draw && GTK_IS_WIDGET_CLASS(klass)) {
      GTK_WIDGET_CLASS(klass)->draw = draw;
  }  
}

GObjectClass*
ada_initialize_class_record
  (GObject*      object,
   gint          nsignals,
   char*         signals[],
   GType         parameters[],
   gint          max_parameters,
   GObjectClass* old_class_record,
   gchar*        type_name,
   gint          num_virtual_functions,
   gpointer*     virtual_functions)
{
  GObjectClass* klass;

  if (!old_class_record)
    {
      /* Note: The memory allocated in this function is never freed. No need
         to worry, since this is only allocated once per user's widget type,
         and might be used until the end of the application */

      /* Right now, object->klass points to the ancestor's class */
      GType ancestor = G_TYPE_FROM_CLASS (G_OBJECT_GET_CLASS (object));
      GTypeInfo * class_info = g_new (GTypeInfo, 1);
      GTypeQuery query;
      GType new_type;
      gpointer* virtual;
      int j;

      /* We need to know the ancestor's class/instance sizes */
      g_type_query (ancestor, &query);
                                                
      class_info->class_size = query.class_size
          + nsignals * sizeof (void*)
          + sizeof (GObjectGetPropertyFunc)
          + sizeof (GObjectSetPropertyFunc)
          + sizeof (void*); /* Last one is for virtual functions */
      class_info->base_init = NULL;
      class_info->base_finalize = NULL;
      class_info->class_init = NULL;
      class_info->class_finalize = NULL;
      class_info->class_data = NULL;
         /* Would be nice to use this for the set_property???*/
      class_info->instance_size = query.instance_size;
         /* ??? should be parameter */
      class_info->n_preallocs = 0;
      class_info->instance_init = NULL;
      class_info->value_table = NULL;

      /* Need to create a new type, otherwise Gtk+ won't free objects of
         this type */
      new_type = g_type_register_static (ancestor, type_name, class_info, 0);
      klass = g_type_class_ref (new_type);

      g_assert (klass != NULL);

      /* Initialize signals */
      for (j = 0; j < nsignals; j++) {
         int count = 0;
         guint id;
         GClosure *closure;
       
         while (count < max_parameters &&
                 (parameters [j * max_parameters + count] != G_TYPE_NONE)) {
               count++;
         }

         closure = g_signal_type_cclosure_new
             (new_type, query.class_size + j * sizeof (void*)); /* offset */
       
         id = g_signal_newv
           (signals[j],                       /* signal_name */
            new_type,                         /* itype */
            G_SIGNAL_RUN_LAST,                /* signal_flags */
            closure,                          /* class_closure */
            NULL,                             /* accumulator */
            NULL,                             /* accu_data */
            g_cclosure_marshal_VOID__VOID,    /* c_marshaller, unused at the
              Ada level ??? This probably makes the widget unusable from C */
            G_TYPE_NONE,                      /* return_type */
            count,                            /* n_params */
            parameters + j * max_parameters); /* param_types */
       }

      /* Initialize the function pointers for the new signals to NULL */
      memset ((char*)(klass) + query.class_size, 0,
	      nsignals * sizeof (void*)
	      + sizeof (GObjectGetPropertyFunc)
	      + sizeof (GObjectSetPropertyFunc)
	      + sizeof (void*));

      virtual = (gpointer*) malloc (num_virtual_functions * sizeof (gpointer));
      *((gpointer**)((char*)klass
		     + query.class_size
		     + nsignals * sizeof (void*))) = virtual;

      for (j = 0; j < num_virtual_functions; j++) {
          virtual [j] = virtual_functions [j];
      }
    }

  else {
      klass = g_type_class_ref (G_TYPE_FROM_CLASS (old_class_record));
    }

  ((GTypeInstance*)object)->g_class = (GTypeClass*) klass;

  return klass;
}

void
ada_widget_set_realize (GtkWidget *widget, void (* realize) (GtkWidget *))
{
  GTK_WIDGET_GET_CLASS (widget)->realize = realize;
}

void
ada_widget_set_draw (GtkWidget *widget, gboolean (*draw) (GtkWidget *, cairo_t*))
{
  GTK_WIDGET_GET_CLASS (widget)->draw = draw;
}


void
ada_gtk_widget_set_default_size_allocate_handler
   (gpointer klass, void (*handler)(GtkWidget        *widget,
				    GtkAllocation    *allocation))
{
  GTK_WIDGET_CLASS (klass)->size_allocate = handler;
}

/*****************************************************
 ** Gtk.Selection and Gtk.Dnd functions
 *****************************************************/

guint ada_gtk_dnd_context_targets_count (GdkDragContext* context)
{
  return g_list_length (gdk_drag_context_list_targets (context));
}

void ada_gtk_dnd_context_get_targets (GdkDragContext* context, GdkAtom* result)
{
  GList *glist = gdk_drag_context_list_targets (context);
  GdkAtom* tmp = result;
  while (glist != NULL)
    {
      *tmp++ = (GdkAtom)glist->data;
//      gchar *name = gdk_atom_name ((GdkAtom)glist->data);
//      *tmp++ = name;
      glist = glist->next;
    }
}

/*
 * Gnode macros
 *
 */

gboolean
ada_gnode_is_root (GNode * node)
{
  return G_NODE_IS_ROOT (node);
}

gboolean
ada_gnode_is_leaf (GNode * node)
{
  return G_NODE_IS_LEAF (node);
}

GNode*
ada_gnode_prev_sibling (GNode * node)
{
  return g_node_prev_sibling (node);
}

GNode*
ada_gnode_next_sibling (GNode * node)
{
  return g_node_next_sibling (node);
}

GNode*
ada_gnode_first_child (GNode * node)
{
  return g_node_first_child (node);
}

/*
 *
 * radio_menu_item
 *
 */

GtkWidget*
ada_radio_menu_item_new_from_widget (GtkRadioMenuItem *group)
{
  GSList *l = NULL;
  if (group)
    l = gtk_radio_menu_item_get_group (group);
  return gtk_radio_menu_item_new (l);
}

GtkWidget *
ada_radio_menu_item_new_with_label_from_widget (GtkRadioMenuItem *group,
						const gchar      *label)
{
  GSList *l = NULL;
  if (group)
    l = gtk_radio_menu_item_get_group (group);
  return gtk_radio_menu_item_new_with_label (l, label);
}

/********************
 * GdkPoint
 ********************/

guint
ada_gdk_point_size ()
{
  return sizeof (GdkPoint);
}

/*
 *
 *  GdkCursor
 *
 */

GdkCursor*
ada_gdk_cursor_new (gint cursor_type)
{
  return gdk_cursor_new (cursor_type);
}


/**********************************************************
 **  Support for events
 **********************************************************/

#ifdef _WIN32
#define ada_gdk_invalid_gdouble_value 1.79769313486232e308
#define ada_gdk_invalid_gint_value ((2<<31) - 1)
#define ada_gdk_invalid_guint_value (guint)((2LL<<32) - 1)
#define ada_gdk_invalid_guint32_value (guint32)((2LL<<32) - 1)
#define ada_gdk_invalid_gulong_value (gulong)((2LL<<32) - 1)

#else
extern const gdouble ada_gdk_invalid_gdouble_value;
extern const gint    ada_gdk_invalid_gint_value;
extern const guint   ada_gdk_invalid_guint_value;
extern const guint32 ada_gdk_invalid_guint32_value;
extern const gulong  ada_gdk_invalid_gulong_value;
#endif

GdkAtom
ada_make_atom (gulong num)
{
  return _GDK_MAKE_ATOM (num);
}

gdouble
ada_gdk_event_get_x (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gdouble_value;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.x;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.x;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.x;
    case GDK_CONFIGURE:
      return event->configure.x;
    case GDK_SCROLL:
      return event->scroll.x;
    default:
      break;
    }
  return ada_gdk_invalid_gdouble_value;
}

gdouble
ada_gdk_event_get_y (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gdouble_value;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.y;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.y;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.y;
    case GDK_CONFIGURE:
      return event->configure.y;
    case GDK_SCROLL:
      return event->scroll.y;
    default:
      break;
    }
  return ada_gdk_invalid_gdouble_value;
}

gint
ada_gdk_event_get_width (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_CONFIGURE:
      return event->configure.width;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_height (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_CONFIGURE:
      return event->configure.height;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

gdouble
ada_gdk_event_get_x_root (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gdouble_value;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.x_root;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.x_root;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.x_root;
    case GDK_SCROLL:
      return event->scroll.x_root;
    default:
      break;
    }
  return ada_gdk_invalid_gdouble_value;
}

gdouble
ada_gdk_event_get_y_root (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gdouble_value;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.y_root;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.y_root;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.y_root;
    case GDK_SCROLL:
      return event->scroll.x_root;
    default:
      break;
    }
  return ada_gdk_invalid_gdouble_value;
}

guint
ada_gdk_event_get_button (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_guint_value;

  switch (event->type)
    {
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.button;
    default:
      break;
    }
  return ada_gdk_invalid_guint_value;
}

guint
ada_gdk_event_get_state (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_guint_value;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.state;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.state;
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      return event->key.state;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.state;
    case GDK_PROPERTY_NOTIFY:
      return event->property.state;
    case GDK_SCROLL:
      return event->scroll.state;
    default:
      break;
    }
  return ada_gdk_invalid_guint_value;
}

GdkWindow *
ada_gdk_event_get_subwindow (GdkEvent * event)
{
  if (!event)
    return NULL;

  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.subwindow;
    default:
      break;
    }
  return NULL;
}

gint
ada_gdk_event_get_mode (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.mode;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_detail (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.detail;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_focus (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      return event->crossing.focus;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_direction (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_SCROLL:
      return event->scroll.direction;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

GdkDevice *
ada_gdk_event_get_device_id (GdkEvent * event)
{
  if (!event)
    return NULL;

  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      return event->motion.device;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      return event->button.device;
    case GDK_PROXIMITY_IN:
    case GDK_PROXIMITY_OUT:
      return event->proximity.device;
    default:
      break;
    }
  return NULL;
}

void
ada_gdk_event_get_area (GdkEvent *event, GdkRectangle *area)
{
  if (event->type == GDK_EXPOSE)
    *area = event->expose.area;
  else
    {
      area->width = ada_gdk_invalid_gint_value;
    }
}

cairo_region_t*
ada_gdk_event_get_region (GdkEvent *event)
{
  if (event->type == GDK_EXPOSE)
    return event->expose.region;
  else
    return NULL;
}

gint
ada_gdk_event_get_count (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  if (event->type == GDK_EXPOSE)
    return event->expose.count;
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_in (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  if (event->type == GDK_FOCUS_CHANGE)
    return event->focus_change.in;
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_is_hint (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  if (event->type == GDK_MOTION_NOTIFY)
    return event->motion.is_hint;
  return ada_gdk_invalid_gint_value;
}

gint
ada_gdk_event_get_key_val (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      return event->key.keyval;
    default:
      break;
    }
  return ada_gdk_invalid_gint_value;
}

guint16
ada_gdk_event_get_hardware_keycode (GdkEvent * event)
{
  if (!event)
    return 0;

  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      return event->key.hardware_keycode;
    default:
      break;
    }
  return 0;
}

guint8
ada_gdk_event_get_group (GdkEvent * event)
{
  if (!event)
    return 0;

  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      return event->key.group;
    default:
      break;
    }
  return 0;
}

char *
ada_gdk_event_get_string (GdkEvent * event)
{
  if (!event)
    return NULL;

  /* The type of the event is checked in gdk-event.adb */
  return event->key.string;
}

GdkAtom
ada_gdk_event_get_atom (GdkEvent * event)
{
  if (event->type == GDK_PROPERTY_NOTIFY)
    return event->property.atom;
  return NULL;
}

guint
ada_gdk_event_get_property_state (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_guint_value;

  if (event->type == GDK_PROPERTY_NOTIFY)
    return event->property.state;
  return ada_gdk_invalid_guint_value;
}

gint
ada_gdk_event_get_visibility_state (GdkEvent * event)
{
  if (!event)
    return ada_gdk_invalid_gint_value;

  if (event->type == GDK_VISIBILITY_NOTIFY)
    return event->visibility.state;
  return ada_gdk_invalid_gint_value;
}

GdkAtom
ada_gdk_event_get_selection (GdkEvent * event)
{
  if (!event)
    return NULL;

  if (event->type == GDK_SELECTION_NOTIFY)
    return event->selection.selection;
  return NULL;
}

GdkAtom
ada_gdk_event_get_target (GdkEvent * event)
{
  if (!event)
    return NULL;

  if (event->type == GDK_SELECTION_NOTIFY)
    return event->selection.target;
  return NULL;
}

GdkAtom
ada_gdk_event_get_property (GdkEvent * event)
{
  if (!event)
    return NULL;

  if (event->type == GDK_SELECTION_NOTIFY)
    return event->selection.property;
  return NULL;
}

GdkWindow*
ada_gdk_event_get_requestor (GdkEvent * event)
{
  if (!event)
    return NULL;

  if (event->type == GDK_SELECTION_NOTIFY ||
      event->type == GDK_SELECTION_CLEAR  ||
      event->type == GDK_SELECTION_REQUEST)
    return event->selection.requestor;
  return NULL;
}

GdkEvent *
ada_gdk_event_create (gint type, GdkWindow* win)
{
  GdkEvent* event;

  event = gdk_event_new (type);
  event->any.send_event = TRUE;
  event->any.window = win;

  if (win != NULL)
    g_object_ref (win);

  return event;
}

GdkEventType
ada_gdk_event_get_type (GdkEventAny * event)
{
  return event->type;
}

gint8
ada_gdk_event_get_send_event (GdkEventAny * event)
{
  return event->send_event;
}

GdkWindow *
ada_gdk_event_get_window (GdkEventAny * event)
{
  return event->window;
}

void
ada_gdk_event_set_window (GdkEventAny * event, GdkWindow * window)
{
  event->window = window;
}

/*******************************************************************
 **  Setting the fields of events
 *******************************************************************/

gint
ada_gdk_event_set_x (GdkEvent * event, gdouble x)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.x = x;
      break;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.x = x;
      break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.x = x;
      break;
    case GDK_CONFIGURE:
      event->configure.x = x;
      break;
    case GDK_SCROLL:
      event->scroll.x = x;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_y (GdkEvent * event, gdouble y)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.y = y;
      break;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.y = y;
      break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.y = y;
      break;
    case GDK_CONFIGURE:
      event->configure.y = y;
      break;
    case GDK_SCROLL:
      event->scroll.y = y;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_xroot (GdkEvent * event, gdouble xroot)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.x_root = xroot;
      break;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.x_root = xroot;
      break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.x_root = xroot;
      break;
    case GDK_SCROLL:
      event->scroll.x_root = xroot;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_yroot (GdkEvent * event, gdouble yroot)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.y_root = yroot;
      break;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.y_root = yroot;
      break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.y_root = yroot;
      break;
    case GDK_SCROLL:
      event->scroll.y_root = yroot;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_time (GdkEvent * event, guint32 time)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.time = time;
      break;

    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.time = time;
      break;

    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.time = time;
      break;

    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.time = time;
      break;

    case GDK_PROPERTY_NOTIFY:
      event->property.time = time;
      break;

    case GDK_SELECTION_NOTIFY:
      event->selection.time = time;
      break;

    case GDK_PROXIMITY_IN:
    case GDK_PROXIMITY_OUT:
      event->proximity.time = time;
      break;

    case GDK_SCROLL:
      event->scroll.time = time;
      break;

    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_width (GdkEvent * event, gint width)
{
  switch (event->type)
    {
    case GDK_CONFIGURE:
      event->configure.width = width;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_height (GdkEvent * event, gint height)
{
  switch (event->type)
    {
    case GDK_CONFIGURE:
      event->configure.height = height;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_button (GdkEvent * event, guint button)
{
  switch (event->type)
    {
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.button = button;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_state (GdkEvent * event, guint state)
{
  switch (event->type)
    {
    case GDK_MOTION_NOTIFY:
      event->motion.state = state;
      break;
    case GDK_BUTTON_PRESS:
    case GDK_2BUTTON_PRESS:
    case GDK_3BUTTON_PRESS:
    case GDK_BUTTON_RELEASE:
      event->button.state = state;
      break;
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.state = state;
      break;
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.state = state;
      break;
    case GDK_PROPERTY_NOTIFY:
      event->property.state = state;
      break;
    case GDK_SCROLL:
      event->scroll.state = state;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_subwindow (GdkEvent * event, GdkWindow* win)
{
  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.subwindow = win;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_string (GdkEvent * event, char* str)
{
  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.length = strlen (str);
      event->key.string = str;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_mode (GdkEvent * event, gint mode)
{
  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.mode = mode;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_detail (GdkEvent * event, gint detail)
{
  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.detail = detail;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_direction (GdkEvent * event, GdkScrollDirection direction)
{
  switch (event->type)
    {
    case GDK_SCROLL:
      event->scroll.direction = direction;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_focus (GdkEvent * event, gint focus)
{
  switch (event->type)
    {
    case GDK_ENTER_NOTIFY:
    case GDK_LEAVE_NOTIFY:
      event->crossing.focus = focus;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_area (GdkEvent * event, GdkRectangle area)
{
  if (event->type == GDK_EXPOSE)
    event->expose.area = area;
  else
    return 0;
  return 1;
}

gint
ada_gdk_event_set_in (GdkEvent * event, gint in)
{
  if (event->type == GDK_FOCUS_CHANGE)
    {
      event->focus_change.in = in;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_is_hint (GdkEvent * event, gint is_hint)
{
  if (event->type == GDK_MOTION_NOTIFY)
    {
      event->motion.is_hint = is_hint;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_key_val (GdkEvent * event, gint keyval)
{
  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.keyval = keyval;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_group (GdkEvent * event, guint8 group)
{
  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.group = group;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_hardware_keycode (GdkEvent * event, guint16 keycode)
{
  switch (event->type)
    {
    case GDK_KEY_PRESS:
    case GDK_KEY_RELEASE:
      event->key.hardware_keycode = keycode;
      break;
    default:
      return 0;
    }
  return 1;
}

gint
ada_gdk_event_set_atom (GdkEvent * event, GdkAtom atom)
{
  if (event->type == GDK_PROPERTY_NOTIFY)
    {
      event->property.atom = atom;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_property_state (GdkEvent * event, guint state)
{
  if (event->type == GDK_PROPERTY_NOTIFY)
    {
      event->property.state = state;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_visibility_state (GdkEvent * event, gint state)
{
  if (event->type == GDK_VISIBILITY_NOTIFY)
    {
      event->visibility.state = state;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_selection (GdkEvent * event, GdkAtom selection)
{
  if (event->type == GDK_SELECTION_NOTIFY)
    {
      event->selection.selection = selection;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_target (GdkEvent * event, GdkAtom target)
{
  if (event->type == GDK_SELECTION_NOTIFY)
    {
      event->selection.target = target;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_property (GdkEvent * event, GdkAtom property)
{
  if (event->type == GDK_SELECTION_NOTIFY)
    {
      event->selection.property = property;
      return 1;
    }
  return 0;
}

gint
ada_gdk_event_set_requestor (GdkEvent * event, GdkWindow * requestor)
{
  if (event->type == GDK_SELECTION_NOTIFY)
    {
      event->selection.requestor = requestor;
      return 1;
    }
  return 0;
}

/*
 *
 * GtkStyle
 *
 */

void
ada_style_set_font_description (GtkStyle* style, PangoFontDescription* font)
{
  style->font_desc = font;
}

PangoFontDescription*
ada_style_get_font_description (GtkStyle* style)
{
  return style->font_desc;
}

void
ada_style_set_fg (GtkStyle* style, gint state, GdkColor* color)
{
  if (color != NULL)
    style->fg[state] = *color;
}

GdkColor*
ada_style_get_fg (GtkStyle* style, gint state)
{
  return style->fg + state;
}

void
ada_style_set_bg (GtkStyle* style, gint state, GdkColor* color)
{
  if (color != NULL)
    style->bg[state] = *color;
}

GdkColor*
ada_style_get_bg (GtkStyle* style, gint state)
{
  return style->bg + state;
}

void
ada_style_set_light (GtkStyle* style, gint state, GdkColor* color)
{
  style->light[state] = *color;
}

GdkColor*
ada_style_get_light (GtkStyle* style, gint state)
{
  return style->light + state;
}

void
ada_style_set_dark (GtkStyle* style, gint state, GdkColor* color)
{
  style->dark[state] = *color;
}

GdkColor*
ada_style_get_dark (GtkStyle* style, gint state)
{
  return style->dark + state;
}

void
ada_style_set_mid (GtkStyle* style, gint state, GdkColor* color)
{
  style->mid[state] = *color;
}

GdkColor*
ada_style_get_mid (GtkStyle* style, gint state)
{
  return style->mid + state;
}

void
ada_style_set_text (GtkStyle* style, gint state, GdkColor* color)
{
  style->text[state] = *color;
}

GdkColor*
ada_style_get_text (GtkStyle* style, gint state)
{
  return style->text + state;
}

void
ada_style_set_base (GtkStyle* style, gint state, GdkColor* color)
{
  style->base[state] = *color;
}

GdkColor*
ada_style_get_base (GtkStyle* style, gint state)
{
  return style->base + state;
}

void
ada_style_set_black (GtkStyle* style, GdkColor* color)
{
  style->black = *color;
}

GdkColor*
ada_style_get_black (GtkStyle* style)
{
  return &style->black;
}

void
ada_style_set_white (GtkStyle* style, GdkColor* color)
{
  style->white = *color;
}

GdkColor*
ada_style_get_white (GtkStyle* style)
{
  return &style->white;
}

gint
ada_style_get_x_thickness (GtkStyle* style)
{
  return style->xthickness;
}

gint
ada_style_get_y_thickness (GtkStyle* style)
{
  return style->ythickness;
}

/***************************************************
 *  Functions for Objects
 ***************************************************/

GType
ada_gobject_get_type (GObject* object)
{
  return G_OBJECT_TYPE (object);
}

/***************************************************
 *  Functions for GClosure
 ***************************************************/

void*
ada_gclosure_get_data (GClosure *closure)
{
  return closure->data;
}

/***************************************************
 *  Functions for GValue
 ***************************************************/

gpointer
ada_gvalue_get_pointer (GValue* value)
{
  return value->data[0].v_pointer;
}

void
ada_gvalue_nth (GValue* value, guint num, GValue* val)
{
  *val = *(value + num);
}

int
ada_c_gvalue_size ()
{
  return sizeof (GValue);
}

void
ada_gvalue_set (GValue* value, void *val)
{
  if G_VALUE_HOLDS_CHAR (value)
    g_value_set_char (value, *(gchar*)val);
  else if G_VALUE_HOLDS_UCHAR (value)
    g_value_set_uchar (value, *(guchar*)val);
  else if G_VALUE_HOLDS_BOOLEAN (value)
    g_value_set_boolean (value, *(char*)val);
  else if G_VALUE_HOLDS_INT (value)
    g_value_set_int (value, *(gint*)val);
  else if G_VALUE_HOLDS_UINT (value)
    g_value_set_uint (value, *(guint*)val);
  else if G_VALUE_HOLDS_LONG (value)
    g_value_set_long (value, *(glong*)val);
  else if G_VALUE_HOLDS_ULONG (value)
    g_value_set_ulong (value, *(gulong*)val);
  else if G_VALUE_HOLDS_FLOAT (value)
    g_value_set_float (value, *(gfloat*)val);
  else if G_VALUE_HOLDS_DOUBLE (value)
    g_value_set_double (value, *(gdouble*)val);
  else if G_VALUE_HOLDS_POINTER (value)
    g_value_set_pointer (value, *(gpointer*)val);
  else
    fprintf (stderr, "GtkAda: Return value type not supported\n");
}

/******************************************
 ** Functions for Text_Attributes
 ******************************************/

PangoFontDescription*
ada_text_attributes_get_font (GtkTextAttributes* text_attr)
{
  return text_attr->font;
}

void
ada_text_attributes_set_font (GtkTextAttributes* text_attr,
                              PangoFontDescription* font)
{
  g_return_if_fail (font != NULL);

  /* Free the family name pointer if already allocated */
  pango_font_description_free (text_attr->font);

  /* set the font. Make sure to strdup the font->family_name field
     to avoid dangling pointers. This memory will be deallocated
     during the final unref */
  text_attr->font = pango_font_description_copy (font);
}

GtkJustification
ada_text_attribute_get_justification (GtkTextAttributes* text_attr) {
  return text_attr->justification;
}
void ada_text_attribute_set_justification
  (GtkTextAttributes* attr, GtkJustification justification) {
  attr->justification = justification;
}

GtkTextDirection
ada_text_attribute_get_direction (GtkTextAttributes* text_attr) {
  return text_attr->direction;
}
void ada_text_attribute_set_direction
  (GtkTextAttributes* attr, GtkTextDirection direction) {
  attr->direction = direction;
}

gdouble
ada_text_attribute_get_font_scale (GtkTextAttributes* text_attr) {
  return text_attr->font_scale;
}
void ada_text_attribute_set_font_scale
  (GtkTextAttributes* attr, gdouble scale) {
  attr->font_scale = scale;
}

gint
ada_text_attribute_get_left_margin (GtkTextAttributes* text_attr) {
  return text_attr->left_margin;
}
void ada_text_attribute_set_left_margin
  (GtkTextAttributes* attr, gint margin) {
  attr->left_margin = margin;
}

gint
ada_text_attribute_get_right_margin (GtkTextAttributes* text_attr) {
  return text_attr->right_margin;
}
void ada_text_attribute_set_right_margin
  (GtkTextAttributes* attr, gint margin) {
  attr->right_margin = margin;
}

gint
ada_text_attribute_get_indent (GtkTextAttributes* text_attr) {
  return text_attr->indent;
}
void ada_text_attribute_set_indent
  (GtkTextAttributes* attr, gint indent) {
  attr->indent = indent;
}

gint
ada_text_attribute_get_pixels_above_line (GtkTextAttributes* text_attr) {
  return text_attr->pixels_above_lines;
}
void ada_text_attribute_set_pixels_above_line
  (GtkTextAttributes* attr, gint above) {
  attr->pixels_above_lines = above;
}

gint
ada_text_attribute_get_pixels_below_line (GtkTextAttributes* text_attr) {
  return text_attr->pixels_below_lines;
}
void ada_text_attribute_set_pixels_below_line
  (GtkTextAttributes* attr, gint below) {
  attr->pixels_below_lines = below;
}

gint
ada_text_attribute_get_pixels_inside_wrap (GtkTextAttributes* text_attr) {
  return text_attr->pixels_inside_wrap;
}
void ada_text_attribute_set_pixels_inside_wrap
  (GtkTextAttributes* attr, gint inside) {
  attr->pixels_inside_wrap = inside;
}

GtkWrapMode
ada_text_attribute_get_wrap_mode (GtkTextAttributes* text_attr) {
  return text_attr->wrap_mode;
}
void ada_text_attribute_set_wrap_mode
  (GtkTextAttributes* attr, GtkWrapMode mode) {
  attr->wrap_mode = mode;
}

guint
ada_text_attribute_get_invisible (GtkTextAttributes* text_attr) {
  return text_attr->invisible;
}
void ada_text_attribute_set_invisible
  (GtkTextAttributes* attr, guint invisible) {
  attr->invisible = invisible;
}

guint
ada_text_attribute_get_bg_full_height (GtkTextAttributes* text_attr) {
  return text_attr->bg_full_height;
}
void ada_text_attribute_set_bg_full_height
  (GtkTextAttributes* attr, guint full) {
  attr->bg_full_height = full;
}

guint
ada_text_attribute_get_editable (GtkTextAttributes* text_attr) {
  return text_attr->editable;
}
void ada_text_attribute_set_editable
  (GtkTextAttributes* attr, guint editable) {
  attr->editable = editable;
}

PangoTabArray*
ada_text_attribute_get_tabs (GtkTextAttributes* text_attr) {
  return text_attr->tabs;
}
void ada_text_attribute_set_tabs
  (GtkTextAttributes* attr, PangoTabArray* tabs) {
  attr->tabs = tabs;
}

gint
ada_text_appearance_get_rise (GtkTextAppearance* app) {
  return app->rise;
}
void ada_text_appearance_set_rise (GtkTextAppearance* app, gint rise) {
  app->rise = rise;
}

guint
ada_text_appearance_get_underline (GtkTextAppearance* app) {
  return app->underline;
}
void ada_text_appearance_set_underline (GtkTextAppearance* app, guint under) {
  app->underline = under;
}

guint
ada_text_appearance_get_strikethrough (GtkTextAppearance* app) {
  return app->strikethrough;
}
void ada_text_appearance_set_strikethrough (GtkTextAppearance* app, guint s) {
  app->strikethrough = s;
}

GdkColor
ada_text_appearance_get_fg_color (GtkTextAppearance* app) {
  return app->fg_color;
}
void ada_text_appearance_set_fg_color
  (GtkTextAppearance* app, GdkColor color) {
  app->fg_color = color;
}

GdkColor
ada_text_appearance_get_bg_color (GtkTextAppearance* app) {
  return app->bg_color;
}
void ada_text_appearance_set_bg_color
  (GtkTextAppearance* app, GdkColor color) {
  app->bg_color = color;
}

/******************************************
 ** Functions for Text_Iter
 ******************************************/

void
ada_text_iter_copy (const GtkTextIter *source,
                    GtkTextIter *dest)
{
  *dest = *source;
}

int
ada_c_gtk_text_iter_size ()
{
  return sizeof (GtkTextIter);
}

/**********************************************
 ** Functions for Box
 **********************************************/

GtkWidget*
ada_box_get_child (GtkBox* widget, gint num)
{
  GList * list;
  list = gtk_container_get_children ((GtkContainer*)widget);
  if (list && num < g_list_length (list))
    return ((GtkWidget*) (g_list_nth_data (list, num)));
  return NULL;
}

/**********************************************
 ** Functions for Glib.Glist
 **********************************************/

GList*
ada_list_next (GList* list)
{
  if (list)
    return list->next;
  else
    return NULL;
}

GList*
ada_list_prev (GList* list)
{
  if (list)
    return list->prev;
  else
    return NULL;
}

gpointer
ada_list_get_data (GList* list)
{
  if (list)
     return list->data;
  else
     return NULL;
}

/**********************************************
 ** Functions for Glib.GSlist
 **********************************************/

GSList*
ada_gslist_next (GSList* list)
{
  if (list)
    return list->next;
  else
    return NULL;
}

gpointer
ada_gslist_get_data (GSList* list)
{
  return list->data;
}

gpointer
ada_slist_get_data (GSList* list)
{
  return list->data;
}


/*
 *
 * GdkWindowAttr
 *
 */

GdkWindowAttr*
ada_gdk_window_attr_new (void)
{
  GdkWindowAttr *result;

  result = (GdkWindowAttr*) g_new (GdkWindowAttr, 1);

  if (result)
    {
      result->title = NULL;
      result->visual = NULL;
      result->cursor = NULL;
      result->wmclass_name = NULL;
      result->wmclass_class = NULL;
      /*
       * Here, we only set the pointers to NULL to avoid any dangling
       * pointer. All the other values are left as is. It is the
       * responsibility of the client to make sure they are properly
       * set before they are accessed.
       */
    }

  return result;
}

void
ada_gdk_window_attr_destroy (GdkWindowAttr *window_attr)
{
  g_return_if_fail (window_attr != NULL);

  if (window_attr->title) g_free (window_attr->title);
  if (window_attr->wmclass_name) g_free (window_attr->wmclass_name);
  if (window_attr->wmclass_class) g_free (window_attr->wmclass_class);

  g_free (window_attr);
}

void
ada_gdk_window_attr_set_title (GdkWindowAttr *window_attr,
			       gchar * title)
{
  g_return_if_fail (window_attr != NULL);

  if (window_attr->title) g_free (window_attr->title);
  window_attr->title = g_strdup (title);
}

gchar*
ada_gdk_window_attr_get_title (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, NULL);

  return window_attr->title;
}

void
ada_gdk_window_attr_set_event_mask (GdkWindowAttr *window_attr,
				    gint event_mask)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->event_mask = event_mask;
}

gint
ada_gdk_window_attr_get_event_mask (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, 0);

  return window_attr->event_mask;
}

void
ada_gdk_window_attr_set_x (GdkWindowAttr * window_attr, gint x)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->x = x;
}

gint
ada_gdk_window_attr_get_x (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, 0);

  return window_attr->x;
}

void
ada_gdk_window_attr_set_y (GdkWindowAttr * window_attr, gint y)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->y = y;
}

gint
ada_gdk_window_attr_get_y (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, 0);

  return window_attr->y;
}

void
ada_gdk_window_attr_set_width (GdkWindowAttr * window_attr, gint width)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->width = width;
}

gint
ada_gdk_window_attr_get_width (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, 0);

  return window_attr->width;
}

void
ada_gdk_window_attr_set_height (GdkWindowAttr * window_attr, gint height)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->height = height;
}

gint
ada_gdk_window_attr_get_height (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, 0);

  return window_attr->height;
}

void
ada_gdk_window_attr_set_wclass (GdkWindowAttr *window_attr,
				GdkWindowWindowClass wclass)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->wclass = wclass;
}

GdkWindowWindowClass
ada_gdk_window_attr_get_wclass (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, GDK_INPUT_OUTPUT);

  return window_attr->wclass;
}

void
ada_gdk_window_attr_set_visual (GdkWindowAttr *window_attr,
				GdkVisual *visual)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->visual = visual;
}

GdkVisual*
ada_gdk_window_attr_get_visual (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, NULL);

  return window_attr->visual;
}

void
ada_gdk_window_attr_set_window_type (GdkWindowAttr *window_attr,
				     GdkWindowType window_type)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->window_type = window_type;
}

GdkWindowType
ada_gdk_window_attr_get_window_type (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, GDK_WINDOW_ROOT);

  return window_attr->window_type;
}

void
ada_gdk_window_attr_set_cursor (GdkWindowAttr *window_attr,
				GdkCursor *cursor)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->cursor = cursor;
}

GdkCursor*
ada_gdk_window_attr_get_cursor (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, NULL);

  return window_attr->cursor;
}

void
ada_gdk_window_attr_set_wmclass_name (GdkWindowAttr *window_attr,
				      gchar *wmclass_name)
{
  g_return_if_fail (window_attr != NULL);

  if (window_attr->wmclass_name) g_free (window_attr->wmclass_name);
  window_attr->wmclass_name = g_strdup (wmclass_name);
}

gchar*
ada_gdk_window_attr_get_wmclass_name (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, NULL);

  return window_attr->wmclass_name;
}

void
ada_gdk_window_attr_set_wmclass_class (GdkWindowAttr *window_attr,
				      gchar *wmclass_class)
{
  g_return_if_fail (window_attr != NULL);

  if (window_attr->wmclass_class) g_free (window_attr->wmclass_class);
  window_attr->wmclass_class = g_strdup (wmclass_class);
}

gchar*
ada_gdk_window_attr_get_wmclass_class (GdkWindowAttr *window_attr)
{
  g_return_val_if_fail (window_attr != NULL, NULL);

  return window_attr->wmclass_class;
}

void
ada_gdk_window_attr_set_override_redirect (GdkWindowAttr *window_attr,
					   gboolean override_redirect)
{
  g_return_if_fail (window_attr != NULL);

  window_attr->override_redirect = override_redirect;
}

gboolean
ada_gdk_window_attr_get_override_redirect (GdkWindowAttr * window_attr)
{
  g_return_val_if_fail (window_attr != NULL, FALSE);

  return window_attr->override_redirect;
}

/*
 *
 * Gdk properties
 *
 */

void
ada_gdk_property_get (GdkWindow	 *window,
		      GdkAtom     property,
		      GdkAtom     type,
		      gulong      offset,
		      gulong      length,
		      gint        pdelete,
		      GdkAtom    *actual_property_type,
		      gint       *actual_format,
		      gint       *actual_length,
		      guchar    **data,
		      gint       *success)
{
  *success = gdk_property_get (window, property, type, offset, length,
			       pdelete, actual_property_type, actual_format,
			       actual_length, data);
}


/******************************************
 ** GEnumClass                           **
 ******************************************/

int
ada_c_enum_value_size ()
{
  return sizeof (GEnumValue);
}

GEnumValue*
ada_genum_nth_value (GEnumClass* klass, guint nth)
{
  return (nth < klass->n_values) ? &(klass->values[nth]) : NULL;
}

gint
ada_genum_get_value (GEnumValue* value)
{
  return value->value;
}

const gchar*
ada_genum_get_name (GEnumValue* value)
{
  return value->value_name;
}

const gchar*
ada_genum_get_nick (GEnumValue* value)
{
  return value->value_nick;
}

/******************************************
 ** GFlags                               **
 ******************************************/

GFlagsValue*
ada_gflags_nth_value (GFlagsClass* klass, guint nth)
{
  return (nth < klass->n_values) ? &(klass->values[nth]) : NULL;
}

gint
ada_gflags_get_value (GFlagsValue* value)
{
  return value->value;
}

const gchar*
ada_gflags_get_name (GFlagsValue* value)
{
  return value->value_name;
}

const gchar*
ada_gflags_get_nick (GFlagsValue* value)
{
  return value->value_nick;
}

/******************************************
 ** GParamSpec                           **
 ******************************************/

const char*
ada_gparam_get_name (GParamSpec* param)
{
  return param->name;
}

GParamFlags
ada_gparam_get_flags (GParamSpec* param)
{
  return param->flags;
}

GType
ada_gparam_get_owner_type (GParamSpec* param)
{
  return param->owner_type;
}

GType
ada_gparam_get_value_type (GParamSpec* param)
{
  return G_PARAM_SPEC_VALUE_TYPE (param);
}

void
ada_gparam_set_value_type (GParamSpec* param, GType value_type)
{
  G_PARAM_SPEC_VALUE_TYPE (param) = value_type;
}

gint8
ada_gparam_get_minimum_char (GParamSpecChar* param)
{
  return param->minimum;
}

gint8
ada_gparam_get_maximum_char (GParamSpecChar* param)
{
  return param->maximum;
}

gint8
ada_gparam_get_default_char (GParamSpecChar* param)
{
  return param->default_value;
}

guint8
ada_gparam_get_minimum_uchar (GParamSpecUChar* param)
{
  return param->minimum;
}

guint8
ada_gparam_get_maximum_uchar (GParamSpecUChar* param)
{
  return param->maximum;
}

guint8
ada_gparam_get_default_uchar (GParamSpecUChar* param)
{
  return param->default_value;
}

gboolean
ada_gparam_get_default_boolean (GParamSpecBoolean* param)
{
  return param->default_value;
}

gint
ada_gparam_get_minimum_int (GParamSpecInt* param)
{
  return param->minimum;
}

gint
ada_gparam_get_maximum_int (GParamSpecInt* param)
{
  return param->maximum;
}

gint
ada_gparam_get_default_int (GParamSpecInt* param)
{
  return param->default_value;
}

guint
ada_gparam_get_minimum_uint (GParamSpecUInt* param)
{
  return param->minimum;
}

guint
ada_gparam_get_maximum_uint (GParamSpecUInt* param)
{
  return param->maximum;
}

guint
ada_gparam_get_default_uint (GParamSpecUInt* param)
{
  return param->default_value;
}

glong
ada_gparam_get_minimum_long (GParamSpecLong* param)
{
  return param->minimum;
}

glong
ada_gparam_get_maximum_long (GParamSpecLong* param)
{
  return param->maximum;
}

glong
ada_gparam_get_default_long (GParamSpecLong* param)
{
  return param->default_value;
}

gulong
ada_gparam_get_minimum_ulong (GParamSpecULong* param)
{
  return param->minimum;
}

gulong
ada_gparam_get_maximum_ulong (GParamSpecULong* param)
{
  return param->maximum;
}

gulong
ada_gparam_get_default_ulong (GParamSpecULong* param)
{
  return param->default_value;
}

gunichar
ada_gparam_get_default_unichar (GParamSpecUnichar* param)
{
  return param->default_value;
}

gint
ada_gparam_get_default_enum (GParamSpecEnum* param)
{
  return param->default_value;
}

GEnumClass*
ada_gparam_get_enum_class_enum (GParamSpecEnum* param)
{
  return param->enum_class;
}

GFlagsClass*
ada_gparam_get_flags_flags (GParamSpecFlags* param)
{
  return param->flags_class;
}

glong
ada_gparam_get_default_flags (GParamSpecFlags* param)
{
  return param->default_value;
}

gfloat
ada_gparam_get_minimum_gfloat (GParamSpecFloat* param)
{
  return param->minimum;
}

gfloat
ada_gparam_get_maximum_gfloat (GParamSpecFloat* param)
{
  return param->maximum;
}

gfloat
ada_gparam_get_default_gfloat (GParamSpecFloat* param)
{
  return param->default_value;
}

gfloat
ada_gparam_get_epsilon_gfloat (GParamSpecFloat* param)
{
  return param->epsilon;
}

gdouble
ada_gparam_get_minimum_gdouble (GParamSpecDouble* param)
{
  return param->minimum;
}

gdouble
ada_gparam_get_maximum_gdouble (GParamSpecDouble* param)
{
  return param->maximum;
}

gdouble
ada_gparam_get_default_gdouble (GParamSpecDouble* param)
{
  return param->default_value;
}

gdouble
ada_gparam_get_epsilon_gdouble (GParamSpecDouble* param)
{
  return param->epsilon;
}

gchar*
ada_gparam_default_string (GParamSpecString* param)
{
  return param->default_value;
}

gchar*
ada_gparam_cset_first_string (GParamSpecString* param)
{
  return param->cset_first;
}

gchar*
ada_gparam_cset_nth_string (GParamSpecString* param)
{
  return param->cset_nth;
}

gchar
ada_gparam_substitutor_string (GParamSpecString* param)
{
  return param->substitutor;
}

gboolean
ada_gparam_ensure_non_null_string (GParamSpecString* param)
{
  return param->ensure_non_null != 0;
}

/******************************************
 ** New widgets
 ******************************************/

void
ada_set_properties_handlers (gpointer klass,
			     GObjectSetPropertyFunc set_handler,
			     GObjectGetPropertyFunc get_handler)
{
  G_OBJECT_CLASS (klass)->set_property = set_handler;
  G_OBJECT_CLASS (klass)->get_property = get_handler;
}

GObjectGetPropertyFunc
ada_real_get_property_handler (GObject* object)
{
  GTypeQuery query;
  g_type_query (G_TYPE_FROM_INSTANCE (object), &query);
  return *(GObjectGetPropertyFunc*)((char*)(G_OBJECT_GET_CLASS (object))
				  + query.class_size
				    - sizeof (GObjectGetPropertyFunc)
				  - sizeof (GObjectSetPropertyFunc));
}

void
ada_set_real_get_property_handler (gpointer klass,
				   GObjectGetPropertyFunc handler)
{
  GTypeQuery query;
  g_type_query (G_TYPE_FROM_CLASS (klass), &query);
  *(GObjectGetPropertyFunc*)((char*)(klass)
			     + query.class_size
			     - sizeof (GObjectGetPropertyFunc)
			     - sizeof (GObjectSetPropertyFunc)) = handler;
}

GObjectSetPropertyFunc
ada_real_set_property_handler (GObject* object)
{
  GTypeQuery query;
  g_type_query (G_TYPE_FROM_INSTANCE (object), &query);
  return *(GObjectSetPropertyFunc*)((char*)(G_OBJECT_GET_CLASS (object))
				  + query.class_size
				  - sizeof (GObjectSetPropertyFunc));
}

void
ada_set_real_set_property_handler (gpointer klass,
				   GObjectSetPropertyFunc handler)
{
  GTypeQuery query;
  g_type_query (G_TYPE_FROM_CLASS (klass), &query);
  *(GObjectSetPropertyFunc*)((char*)(klass)
			    + query.class_size
			    - sizeof (GObjectSetPropertyFunc)) = handler;
}

void
ada_genum_create_enum_value
  (gint value, gchar* name, gchar* nick, GEnumValue* val)
{
  val->value = value;
  val->value_name = g_strdup (name);
  val->value_nick = g_strdup (nick);
}

/******************************************
 ** GType                                **
 ******************************************/

GType
ada_g_object_get_type (GObject* object)
{
  return G_OBJECT_TYPE (object);
}

GType
ada_gtype_fundamental (GType type)
{
  return G_TYPE_FUNDAMENTAL (type);
}

gboolean
ada_g_type_is_interface (GType type)
{
  return G_TYPE_IS_INTERFACE (type);
}

/******************************************
 ** Functions for Tree_Iter
 ******************************************/

void
ada_tree_iter_copy (const GtkTreeIter *source,
                    GtkTreeIter *dest)
{
  *dest = *source;
}

/******************************************
 ** Mouse handling                       **
 ******************************************/

#ifdef _WIN32

#include <windows.h>
#include <gdk/gdkwin32.h>

void *
ada_gdk_get_window_id (GdkWindow *w)
{
  return (void *)GDK_WINDOW_HWND (w);
}

#elif defined (__APPLE__)
/*  Disable this function under Apple, since under Tiger the call to
    XWarpPointer requires explicit linker flags pointing to X11 libs,
    and when using Quartz, there is no X11 lib at all.
*/

void *
ada_gdk_get_window_id (GdkWindow *w)
{
  return NULL;
}

#else
#include <gdk/gdkx.h>

void *
ada_gdk_get_window_id (GdkWindow *w)
{
  return (void *) GDK_WINDOW_XID (w);
}

#endif

/******************************************
 ** Handling of tree Freeze/Thaw         **
 ******************************************/

gint
ada_gtk_tree_view_freeze_sort (GtkTreeStore* tree)
{
  gint save;
  GtkSortType order;
  gtk_tree_sortable_get_sort_column_id
    (GTK_TREE_SORTABLE (tree), &save, &order);
  gtk_tree_sortable_set_sort_column_id (GTK_TREE_SORTABLE (tree), -2, order);
  return save;
}

void
ada_gtk_tree_view_thaw_sort (GtkTreeStore* tree, gint id)
{
  gint save;
  GtkSortType order;
  gtk_tree_sortable_get_sort_column_id
    (GTK_TREE_SORTABLE (tree), &save, &order);
  gtk_tree_sortable_set_sort_column_id
    (GTK_TREE_SORTABLE (tree), id, order);
}

/*****************************************************
 ** Glib
*****************************************************/

struct CustomGSource
{
  GSource source;
  gpointer user_data;
};

GSourceFuncs*
ada_allocate_g_source_funcs
  (gpointer prepare, gpointer check, gpointer dispatch, gpointer finalize)
{
  GSourceFuncs* result;
  result = (GSourceFuncs*) malloc (sizeof (GSourceFuncs));

  result->prepare  = prepare;
  result->check    = check;
  result->dispatch = dispatch;
  result->finalize = finalize;
  return result;
}

GSource*
ada_g_source_new (GSourceFuncs* type, gpointer user_data)
{
  struct CustomGSource* result =
    (struct CustomGSource*)g_source_new (type, sizeof (struct CustomGSource));
  result->user_data = user_data;
  return (GSource*)result;
}

gpointer
ada_g_source_get_user_data (GSource* source)
{
  return ((struct CustomGSource*)source)->user_data;
}

/********************************************************
 ** Gtk_Selection
********************************************************/

int
ada_string_array_length (gchar** uris)
{
  int count = 0;
  gchar** tmp = uris;
  while (*tmp) {
    tmp++;
    count++;
  }
  return count;
}

gchar*
ada_string_array_get (gchar** uris, int index)
{
  return uris[index];
}

/***********************************************************
 ** Gtk_Text_Buffer
***********************************************************/

void
ada_gtk_text_buffer_insert_with_tags
 (GtkTextBuffer *buffer,
  GtkTextIter   *iter,
  const gchar   *text,
  gint           len,
  GtkTextTag    *tag)
{
  gtk_text_buffer_insert_with_tags
    (buffer, iter, text, len, tag, NULL);
}

void
ada_gtk_text_buffer_insert_with_tags_by_name
 (GtkTextBuffer *buffer,
  GtkTextIter   *iter,
  const gchar   *text,
  gint           len,
  const gchar   *name)
{
  gtk_text_buffer_insert_with_tags_by_name
    (buffer, iter, text, len, name, NULL);
}

GtkTextTag*
ada_gtk_text_buffer_create_tag (GtkTextBuffer* buffer, const gchar* name)
{
   return gtk_text_buffer_create_tag (buffer, name, NULL);
}

/***********************************************************
 ** Gtk_File_Filter
***********************************************************/

const gchar*
ada_file_filter_info_get_filename (GtkFileFilterInfo* info)
{
  if (info->contains & GTK_FILE_FILTER_FILENAME) {
    return info->filename;
  } else {
    return NULL;
  }
}

const gchar*
ada_file_filter_info_get_uri (GtkFileFilterInfo* info)
{
  if (info->contains & GTK_FILE_FILTER_URI) {
    return info->uri;
  } else {
    return NULL;
  }
}

const gchar*
ada_file_filter_info_get_display_name (GtkFileFilterInfo* info)
{
  if (info->contains & GTK_FILE_FILTER_DISPLAY_NAME) {
    return info->display_name;
  } else {
    return NULL;
  }
}

const gchar*
ada_file_filter_info_get_mime_type (GtkFileFilterInfo* info)
{
  if (info->contains & GTK_FILE_FILTER_MIME_TYPE) {
    return info->mime_type;
  } else {
    return NULL;
  }
}

/***********************************************************
 ** Gtk_File_Chooser_Dialog
***********************************************************/

GtkWidget *
ada_gtk_file_chooser_dialog_new
  (const gchar          *title,
   GtkWindow            *parent,
   GtkFileChooserAction  action)
{
  return gtk_file_chooser_dialog_new
    (title, parent, action, NULL, (char *)NULL);
}

/***********************************************************
 ** Gtk_Recent_Chooser_Dialog
***********************************************************/

GtkWidget*
ada_gtk_recent_chooser_dialog_new
  (const gchar *title,
   GtkWindow   *parent)
{
  return gtk_recent_chooser_dialog_new (title, parent, NULL, NULL);
}

GtkWidget*
ada_gtk_recent_chooser_dialog_new_for_manager
  (const gchar      *title,
   GtkWindow        *parent,
   GtkRecentManager *manager)
{
  return gtk_recent_chooser_dialog_new_for_manager
    (title, parent, manager, NULL, NULL);
}

/**************************************************************
 **  Gtk_Message_Dialog
**************************************************************/

void
ada_gtk_message_dialog_format_secondary_markup
  (GtkMessageDialog* dialog, gchar* msg)
{
  gtk_message_dialog_format_secondary_markup (dialog, msg);
}

void
ada_gtk_message_dialog_format_secondary_text
  (GtkMessageDialog* dialog, gchar* msg)
{
  gtk_message_dialog_format_secondary_text (dialog, msg);
}

GtkWidget*
ada_gtk_message_dialog_new
  (GtkWindow      *parent,
  GtkDialogFlags  flags,
  GtkMessageType  type,
  GtkButtonsType  buttons,
  const gchar    *message)
{
  return gtk_message_dialog_new (parent, flags, type, buttons, message);
}

GtkWidget*
ada_gtk_message_dialog_new_with_markup
  (GtkWindow      *parent,
  GtkDialogFlags  flags,
  GtkMessageType  type,
  GtkButtonsType  buttons,
  const gchar    *message)
{
  return gtk_message_dialog_new_with_markup
    (parent, flags, type, buttons, message);
}

/**************************************************************
 **  Gtk_Bindings
**************************************************************/

void
ada_gtk_binding_entry_add_signal_NO
  (GtkBindingSet* set, guint keyval, GdkModifierType modifier,
   const gchar* signal_name)
{
  gtk_binding_entry_add_signal (set, keyval, modifier, signal_name, 0);
}

void
ada_gtk_binding_entry_add_signal_int
  (GtkBindingSet* set, guint keyval, GdkModifierType modifier,
   const gchar* signal_name, gint arg1)
{
  gtk_binding_entry_add_signal
    (set, keyval, modifier, signal_name, 1,
     G_TYPE_INT, arg1);
}

void
ada_gtk_binding_entry_add_signal_int_int
  (GtkBindingSet* set, guint keyval, GdkModifierType modifier,
   const gchar* signal_name, gint arg1, gint arg2)
{
  gtk_binding_entry_add_signal
    (set, keyval, modifier, signal_name, 2,
     G_TYPE_INT, arg1, G_TYPE_INT, arg2);
}

void
ada_gtk_binding_entry_add_signal_bool
  (GtkBindingSet* set, guint keyval, GdkModifierType modifier,
   const gchar* signal_name, gboolean arg1)
{
  gtk_binding_entry_add_signal
    (set, keyval, modifier, signal_name, 1,
     G_TYPE_BOOLEAN, arg1);
}

GdkModifierType
ada_gdk_get_default_modifier ()
{
#ifdef GDK_QUARTZ_BACKEND
  return GDK_MOD1_MASK;
#else
  return GDK_CONTROL_MASK;
#endif
}


// GtkPlug is only build on X11 backends

#ifndef GDK_WINDOWING_X11
int gtk_plug_get_type() {
   return 0;
}
int gtk_socket_get_type() {
   return 0;
}
#endif
