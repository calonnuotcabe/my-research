ưIMAGE_NAME=linux26-builder

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -it \
		-v $(PWD)/linux-2.6.32:/kernel/linux-2.6.32 \
		$(IMAGE_NAME)
