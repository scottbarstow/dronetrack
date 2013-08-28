export NODE_ENV="test"
find ./test/ -name "*.test.js" | xargs  mocha --require should --reporter dot --ui bdd --recursive -s 1000 -t 120s