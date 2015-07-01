SUBDIRS = openmp cilk

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
			 $(MAKE) -C $@

