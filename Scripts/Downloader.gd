class_name Downloader

extends Node

@onready var _http: HTTPRequest = $HTTPRequest

func _ready():
	_http.request_completed.connect(_on_request_completed)

func download(url: String, file_path: String):
	print("[Downloader.download] url=",
		url, ", file_path=", file_path, "\n")
	_http.set_download_file(file_path)
	var request = _http.request(url)
	if request != OK:
		push_error("Http request error")

func _on_request_completed(result, response_code, headers, body):
	print("[Downloader._on_request_completed] result=",
		result, ", response_code=", response_code,
		", headers=", headers, ", body=", body, "\n")
	if result != OK:
		push_error("Download Failed")
