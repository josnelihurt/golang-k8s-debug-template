

prepare_k8s:
	minikube start
	./scripts/install_namespace.sh

debug:
	./scripts/build_app_debug.sh
	./scripts/build_docker_debug.sh
	./scripts/run_debug_srv.sh