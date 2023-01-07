CLUSTER_NAME := app-name-stateless

# Makefile as a deploy script
# `make app-prod.d` を実行すると cdk deploy "*app-prod*" が走ります。
# `static` stack がデプロイされる場合は自動的にビルドも行われます。

%.s:
	cdk synth "*$**"

%.d:
	@IS_DEV="$(findstring $*,static-dev)"; IS_PROD="$(findstring $*,static-prod)"; \
		[ -z "$$IS_DEV$$IS_PROD" ] || [ -n "$$IS_DEV" -a -n "$$IS_PROD" ] || \
		if [ -n "$$IS_PROD" ]; then \
		echo npm run build:prod; npm run build:prod --prefix ../frontend; else \
		echo run build:dev; npm run build:dev --prefix ../frontend; fi
	cdk deploy "*$**"
	docker rmi -f $$(docker images | grep -e 'cdkasset' -e 'amazonaws.com/cdk-' | awk 'NR>1{print $3}' ) >/dev/null 2>&1 || true

# dev.exec, prod.exec で ECS EXEC を使用可能
%.exec:
	CLUSTER=$$(aws ecs list-clusters --output text | grep $(CLUSTER_NAME)-$* | cut -d/ -f2); \
	TASK=$$(aws ecs list-tasks --cluster $$CLUSTER --output text | cut -d/ -f3); \
	aws ecs execute-command --cluster $$CLUSTER --task $$TASK --container app --interactive --command '/bin/sh'
