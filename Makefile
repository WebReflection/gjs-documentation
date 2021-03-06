outdir ?= .
prefix ?= /opt/gnome
datadir ?= $(prefix)/share
girdir = $(datadir)/gir-1.0

GENERATED_NAMESPACES = \
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
	Cogl-2.0		\
	CoglPango-1.0		\
	Clutter-1.0		\
	GtkClutter-1.0		\
	GtkSource-3.0		\
	Atk-1.0			\
	Gst-1.0			\
	Soup-2.4		\
	TelepathyGLib-0.12	\
	Gcr-3			\
	Gck-1			\
	Secret-1		\
	Notify-0.7		\
	GWeather-3.0		\
	WebKit2-4.0

NAMESPACES = $(GENERATED_NAMESPACES)

GIRS = $(foreach g,$(NAMESPACES),$(girdir)/$(g).gir)
GENERATED_MALLARDS = $(foreach g,$(GENERATED_NAMESPACES),$(outdir)/generated/$(g))
MALLARDS = $(GENERATED_MALLARDS)
HTMLS = $(foreach g,$(NAMESPACES),html/$(g))

all: $(HTMLS)

$(outdir)/generated/%: $(girdir)/%.gir
	g-ir-doc-tool --language=Gjs -o $@ $<
	touch $@

update-mallard: $(MALLARDS)

html/%: $(outdir)/generated/%
	mkdir -p $@
	yelp-build html -o $@ $<
	touch $@

upload: all
	rsync -av --delete html/ master.gnome.org:public_html/docs/

pages:
	git pull --rebase
	mkdir -p ~/tmp-gjs-documentation
	cp -r ./html/* ~/tmp-gjs-documentation
	sh generate-index-html
	git checkout gh-pages
	cp -r ~/tmp-gjs-documentation/* ./
	rm -rf ~/tmp-gjs-documentation
	git add .
	git commit -m 'updated documentation'
	git push
	git checkout master

clean:
	-rm -fr $(HTMLS)
maintainerclean:
	-rm -fr $(GENERATED_MALLARDS)
