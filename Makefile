sketch := $(CURDIR)

all: install compile upload
.PHONY: all

compile: install
	arduino-cli compile -b esp32:esp32:esp32 --verbose $(sketch)
	@echo $(CURDIR)
.PHONY: compile

install:
	@[ -f "$$HOME/.arduino15/arduino-cli.yaml" ] || arduino-cli config init
	@grep -qE 'additional_urls.*esp32.*\.json' "$$HOME/.arduino15/arduino-cli.yaml" || \
		sed -ri '/additional_urls/s,.*,  additional_urls: [https://dl.espressif.com/dl/package_esp32_index.json],' \
		$$HOME/.arduino15/arduino-cli.yaml \
		&& arduino-cli core update-index
	arduino-cli core install esp32:esp32
	arduino-cli lib install 'Adafruit BME280 Library'
	arduino-cli lib install 'ESP8266 Influxdb'
	arduino-cli lib install 'Adafruit BMP280 Library'
.PHONY: install

upload: compile
	arduino-cli upload -p /dev/ttyUSB0 --fqbn esp32:esp32:esp32 --verbose $(sketch)
.PHONY: upload
