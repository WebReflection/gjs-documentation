outdir ?= .
prefix ?= /opt/gnome
datadir ?= $(prefix)/share
girdir = $(datadir)/gir-1.0

STATIC_NAMESPACES = \
	GLib-2.0		\
	Gio-2.0			\
	GObject-2.0		\

GENERATED_NAMESPACES = \
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
	TelepathyGLib-0.12	\
	TelepathyLogger-0.2	\
	EDataServer-1.2		\
	EBook-1.2		\
	EBookContacts-1.2	\
	Gcr-3			\
	Gck-1			\
	Secret-1		\
	Gda-6.0			\
	Notify-0.7		\
	Polkit-1.0		\
	Champlain-0.12		\
	GtkChamplain-0.12	\
	GeocodeGlib-1.0		\
	GWeather-3.0		\
	Grl-0.2			\
	GrlNet-0.2		\
	GrlPls-0.2

NAMESPACES = $(STATIC_NAMESPACES) $(GENERATED_NAMESPACES)

GIRS = $(foreach g,$(NAMESPACES),$(girdir)/$(g).gir)
MALLARDS = \
	$(foreach g,$(STATIC_NAMESPACES),$(outdir)/static/$(g)) \
	$(foreach g,$(GENERATED_NAMESPACES),$(outdir)/generated/$(g))
HTMLS = $(foreach g,$(NAMESPACES),html/$(g))

all: $(HTMLS)

$(outdir)/static/%: $(girdir)/%.gir
	g-ir-doc-tool --language=Gjs -o $@ $<
	touch $@
$(outdir)/generated/%: $(girdir)/%.gir
	g-ir-doc-tool --language=Gjs -o $@ $<
	touch $@

update-mallard: $(MALLARDS)

html/%: $(outdir)/static/%
	mkdir -p $@
	yelp-build html -o $@ $<
	touch $@
html/%: $(outdir)/generated/%
	mkdir -p $@
	yelp-build html -o $@ $<
	touch $@

upload: all
	rsync -av --delete html/ master.gnome.org:public_html/docs/

clean:
	-rm -fr $(HTMLS)
