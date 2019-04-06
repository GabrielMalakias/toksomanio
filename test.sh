curl -X POST \
  http://toksomanio.kubernetes.gabrielmalakias.com/api/tasks \
  -H 'accept: text/plain' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
  "tasks":[
    {
      "name":"task-1",
      "command":"touch /tmp/result"
    },
    {
      "name":"task-2",
      "command":"cat /tmp/result",
      "requires":[
        "task-3"
         ]
    },
    {
      "name":"task-3",
      "command":"echo '\''Does it work? Then send me an email: gabriel07malakias@gmail.com '\'' > /tmp/result",
      "requires":[
        "task-1"
         ]
    }
  ]
}
' | bash
