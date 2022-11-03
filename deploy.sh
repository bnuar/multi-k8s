docker build -t bnuar/multi-client:latest -t bnuar/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t bnuar/multi-server:latest -t bnuar/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t bnuar/multi-worker:latest -t bnuar/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push bnuar/multi-client:latest
docker push bnuar/multi-server:latest
docker push bnuar/multi-worker:latest

docker push bnuar/multi-client:$SHA
docker push bnuar/multi-server:$SHA
docker push bnuar/multi-worker:$SHA

# because we have kubectl installed on the travis file command line "  - gcloud components update kubectl"
# we can now just do kubectl command lines
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=bnuar/multi-server:$SHA
kubectl set image deployments/client-deployment client=bnuar/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=bnuar/multi-worker:$SHA