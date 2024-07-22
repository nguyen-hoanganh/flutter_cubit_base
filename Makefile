.PHONY: build-runner
build-runner:
	flutter packages pub run build_runner build --delete-conflicting-outputs 
generate: 
	flutter gen-l10n
	
.PHONY: watch-runner
watch-runner:
	flutter packages pub run build_runner watch --delete-conflicting-outputs
