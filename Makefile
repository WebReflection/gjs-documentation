
prefix ?= /opt/gnome
datadir ?= $(prefix)/share
girdir = $(datadir)/gir-1.0

NAMESPACES = GLib-2.0 Gio-2.0 GObject-2.0
GIRS = $(foreach g,$(NAMESPACES),$(girdir)/$(g).gir)
MALLARDS = $(foreach g,$(NAMESPACES),$(g)-Gjs)
HTMLS = $(foreach g,$(NAMESPACES),html/$(g))

all: $(HTMLS)

%-Gjs: $(girdir)/%.gir
	g-ir-doc-tool --language=Gjs -o $@ $<

update-mallard: $(MALLARDS)

html/%: %-Gjs
	mkdir $@
	yelp-build html -o $@ $<

upload: all
	rsync -av --delete html/ master.gnome.org:public_html/docs/

clean:
	-rm -fr $(HTMLS)
