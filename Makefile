.PHONY: all clean-ignition clean serve

BUTANE_BASE_SRCS := $(wildcard butane/common/*.bu)
BUTANE_SERVICE_SRCS := $(wildcard butane/services/*.bu)
BUTANE_NODE_SRCS := $(wildcard butane/nodes/*.bu)

IGNITION_BASE_CONFIGS := $(BUTANE_BASE_SRCS:butane/common/%.bu=ignition/common/%.ign)
IGNITION_SERVICE_CONFIGS := $(BUTANE_SERVICE_SRCS:butane/services/%.bu=ignition/services/%.ign)
IGNITION_NODE_CONFIGS := $(BUTANE_NODE_SRCS:butane/nodes/%.bu=ignition/nodes/%.ign)

all: ignition

ignition: ${IGNITION_BASE_CONFIGS} ${IGNITION_SERVICE_CONFIGS} ${IGNITION_NODE_CONFIGS}

clean: clean-ignition

clean-ignition:
	find ./ignition/ -name \*.ign -delete

ignition/common/%.ign: butane/common/%.bu
	@echo "[Base] Converting $< to ignition"
	mkdir -p ignition/common
	butane --pretty --strict --files-dir . -o $@ $<

ignition/services/%.ign: butane/services/%.bu ${IGNITION_BASE_CONFIGS}
	@echo "[Services] Converting $< to ignition"
	mkdir -p ignition/services
	butane --pretty --strict --files-dir . -o $@ $<

ignition/nodes/%.ign: butane/nodes/%.bu ${IGNITION_BASE_CONFIGS} ${IGNITION_SERVICE_CONFIGS}
	@echo "[Nodes] Converting $< to ignition"
	mkdir -p ignition/nodes
	butane --pretty --strict --files-dir . -o $@ $<

serve: |ignition
	@echo "[Serve] Serving node configs on the following addresses on port 8000:"
	@echo "$$(ifconfig | grep inet\ )"
	python -m http.server -d ./ignition/nodes
