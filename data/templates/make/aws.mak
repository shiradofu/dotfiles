CLUSTER_NAME := cluster

# AWS CDK
# make app-prod.d => cdk deploy "*app-prod*"
%.s:
	cdk synth "*$**"

%.d:
	cdk deploy "*$**"

# dev.exec, prod.exec で ECS EXEC を使用可能
%.exec:
	CLUSTER=$$(aws ecs list-clusters --output text | grep $(CLUSTER_NAME)-$* | cut -d/ -f2); \
	TASK=$$(aws ecs list-tasks --cluster $$CLUSTER --output text | cut -d/ -f3); \
	aws ecs execute-command --cluster $$CLUSTER --task $$TASK --container app --interactive --command '/bin/sh'
