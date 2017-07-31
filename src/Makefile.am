## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = urutau_icons.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(URUTAU_ICONS_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = urutau_icons

urutau_icons_SOURCES = \
	urutau_icons.vala config.vapi

urutau_icons_VALAFLAGS =  --pkg gtk+-3.0  \
	--pkg gtk+-3.0


urutau_icons_LDFLAGS = \
	-Wl,--export-dynamic

urutau_icons_LDADD = $(URUTAU_ICONS_LIBS)




EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

