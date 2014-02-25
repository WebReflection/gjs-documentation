outdir ?=
prefix ?= /opt/gnome
datadir ?= $(prefix)/share
girdir = $(datadir)/gir-1.0

NAMESPACES = \
	GLib-2.0		\
	Gio-2.0			\
	GObject-2.0		\
	cairo-1.0		\
	Pango-1.0		\
	PangoCairo-1.0		\
	Gtk-3.0			\
	Gdk-3.0			\
	GdkX11-3.0		\
	GdkPixbuf-2.0		\
	Cogl-1.0		\
	CoglPango-1.0		\
	Clutter-1.0		\
	GtkClutter-1.0		\
	GtkSource-3.0		\
	WebKit2-3.0		\
	WebKit2WebExtension-3.0	\
	Atk-1.0			\
	Tracker-1.0		\
	Gst-1.0			\
	GUPnP-1.0		\
	GSSDP-1.0		\
	GUdev-1.0		\
	GUsb-1.0		\
	NMClient-1.0		\
	NetworkManager-1.0	\
	Soup-2.4		\
	Rest-0.7		\
	RestExtras-0.7		\
	GData-0.0		\
	GFBGraph-0.2		\
	Zpj-0.0			\
	Goa-1.0			\
	TelepathyGLib-0.12	\
	TelepathyLogger-0.2	\
	EDataServer-1.2		\
	EBook-1.2		\
	EBookContacts-1.2	\
	ECal-1.2		\
	Gcr-3			\
	Gck-1			\
	Secret-1		\
	Gda-6.0			\
	PackageKitGlib-1.0	\
	Notify-0.7		\
	Poppler-0.18		\
	EvinceDocument-3.0	\
	EvinceView-3.0		\
	Polkit-1.0		\
	PolkitAgent-1.0		\
	Champlain-0.12		\
	GtkChamplain-0.12	\
	GeocodeGlib-1.0		\
	GWeather-3.0		\
	Grl-0.2			\
	GrlNet-0.2		\
	GrlPls-0.2

GIRS = $(foreach g,$(NAMESPACES),$(girdir)/$(g).gir)
MALLARDS = $(foreach g,$(NAMESPACES),$(outdir)$(g)-Gjs)
HTMLS = $(foreach g,$(NAMESPACES),html/$(g))

all: $(HTMLS)

$(outdir)%-Gjs: $(girdir)/%.gir
	g-ir-doc-tool --language=Gjs -o $@ $<
	touch $@

update-mallard: $(MALLARDS)

html/%: %-Gjs
	mkdir -p $@
	yelp-build html -o $@ $<
	touch $@

upload: all
	rsync -av --delete html/ master.gnome.org:public_html/docs/

clean:
	-rm -fr $(HTMLS)
