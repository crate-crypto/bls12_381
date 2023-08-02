
# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)

# Create a release build.
#
# Usage:
#	make release [target=(|web|nodejs) features=()]

release:
	wasm-pack build ./ --out-dir dist/pkg --release --target $(if $(call eq,$(target),),nodejs,$(target)) $(if $(call eq,$(features),),,--features $(features))

# Create a development build (enable debug info, and disable optimizations).
#
# Usage:
#	make build [target=(|web|nodejs) features=()]

build:
	wasm-pack build ./ --out-dir dist/pkg --dev --target $(if $(call eq,$(target),),nodejs,$(target)) $(if $(call eq,$(features),),,--features $(features))

# Install prerequisites.
#
# Usage:
#	make prerequisite

prerequisite:
	cargo install wasm-pack

# Publish wasm module on `npmjs.org`.
# Default target is `nodejs`.
#
# Usage:
#	make publish [target=(|web|nodejs) features=()]

publish: release
	npm publish ./dist/pkg --tag $(if $(call eq,$(target),),nodejs,$(target))

# Publish wasm module on `npmjs.org` with tag `latest`.
#
# Usage:
#	make publish [target=(|web|nodejs) features=()]

publish.latest: release
	npm publish ./dist/pkg

#
# === .PHONY section
#

.PHONY: \
	release \
	build \
	prerequisite \
	publish \
	publish.latest
