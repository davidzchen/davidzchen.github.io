LESSC = lessc
OBJ = \
	css/app.css

all: $(OBJ)

app_css_DEPS = \
	less/app.less \
	less/variables.less \
	less/base.less \
	less/navbar.less \
	less/blog.less \
	less/callout.less

css/app.css: $(app_css_DEPS)
	$(LESSC) $< $@

clean:
	rm -f $(OBJ)

.SUFFIXES: .css .less

.PHONY: all clean
