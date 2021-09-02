```go
func main() {
	go startTrace()    
}

func startTrace() {
	grpc.EnableTracing = true

	trace.AuthRequest = func(req *http.Request) (any, sensitive bool) {
		return true, true
	}

	go http.ListenAndServe(":9503", nil)
	log.Println("trace listen on 9503")
}
```

- 通过`http://localhost:9503/debug/requests`查看请求
- 通过`http://localhost:9503/debug/events`查看事件