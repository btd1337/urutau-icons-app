/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2017 Helder <helder.bertoldo@gmail.com>
 * 
 * urutau-icons is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * urutau-icons is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;

public class Main : Object 
{

	/* 
	 * Uncomment this line when you are done testing and building a tarball
	 * or installing
	 */
	//const string UI_FILE = Config.PACKAGE_DATA_DIR + "/ui/" + "urutau_icons.ui";
	const string UI_FILE = "src/urutau_icons.ui";

	/* ANJUTA: Widgets declaration for urutau_icons.ui - DO NOT REMOVE */


	public Main ()
	{

		try 
		{
			var builder = new Builder ();
			builder.add_from_file (UI_FILE);
			builder.connect_signals (this);

			var window = builder.get_object ("main-window") as Window;
			/* ANJUTA: Widgets initialization for urutau_icons.ui - DO NOT REMOVE */
			var switch_enable = builder.get_object ("switch_enable") as Switch;
			var lbl_enable = builder.get_object ("lbl-enable") as Label;
			var btn_update = builder.get_object ("btn-update") as Button;
			var btn_tip = builder.get_object ("btn-tip") as Button;
			var btn_submit = builder.get_object ("btn-submit") as Button;
		
			string cmd = "gsettings get org.gnome.desktop.interface icon-theme";
			execute_system_command (cmd);
		
			if(checks_installed ()) {
				btn_update.label = "Update";
				switch_enable.set_visible (true);
				lbl_enable.set_visible (true);
			}else {
				btn_update.label = "Install";
				switch_enable.set_visible (false);
				lbl_enable.set_visible (false);
				
			}


			if("urutau-icons" in execute_system_command (cmd)){
				switch_enable.set_active(true);
			}else {
				switch_enable.set_active (false);
			}

			switch_enable.notify["active"].connect (() => {
				if (switch_enable.active) {
					cmd = "gsettings set org.gnome.desktop.interface icon-theme 'urutau-icons'";
					execute_system_command (cmd);
					stdout.printf("Theme urutau-icons applied\n");
				} else {
					cmd = "gsettings set org.gnome.desktop.interface icon-theme 'elementary'";
					execute_system_command (cmd);
					stdout.printf("Theme elementary applied\n");
				}
			});
		
			btn_update.clicked.connect (() => {
				if(btn_update.label == "Update") {
					update();
				} else {
					install();
				}
			});

			btn_submit.clicked.connect (() => {
				try{
					cmd = "sensible-browser  https://github.com/btd1337/urutau-icons/issues &";
					execute_system_command (cmd);
				} catch (Error e) {
					stderr.printf ("Error opening browser: %s\n", e.message);
				}
			});
		
			btn_tip.clicked.connect (() => {
				cmd = "sensible-browser  https://elementary.io/docs/human-interface-guidelines#iconography &";
				execute_system_command (cmd);
			});
			
			window.show_all ();
		
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}

	public bool checks_installed () {

		var file = File.new_for_path ("/usr/share/icons/urutau-icons");

		if (file.query_exists ()) {
			return true;
		}else {
			return false;
		}	
	}

	public bool checks_git_installed () {
		return true;
	}

	public bool update () {
		try {
			string cmd = "pkexec git -C /usr/share/icons/urutau-icons pull";
			execute_system_command (cmd);
			return true;
		} catch(Error e) { 
			stderr.printf ("Update Error: %s\n", e.message);
			return false;
		}
	}

	 public bool install () {
		 try {
			string cmd = "pkexec git clone https://github.com/btd1337/urutau-icons /usr/share/icons/";
			execute_system_command (cmd);
			return true;

		} catch(Error e) { 
			stderr.printf ("Installation Error: %s\n", e.message);
			return false;
		}
	 }

	 public string execute_system_command (string cmd) {
		int exitCode;
		string std_out;
		try{
			Process.spawn_command_line_sync(cmd, out std_out, null, out exitCode);
			return std_out;
		} catch (Error e) { 
			stderr.printf ("Error: %s\n", e.message);
			return "error";
		}
	 }
	 
	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		Gtk.main ();

		
		return 0;
	}
}

