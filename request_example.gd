extends Control


@onready var http_request: HTTPRequest = $HTTPRequest
@onready var fact: RichTextLabel = %Fact


func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	var error: Error = http_request.request("https://catfact.ninja/fact")
	if error != OK:
		Debug.log("Cat fact API down")


func _on_request_completed(
	_result: int,
	_response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray) -> void:
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response: Dictionary = json.get_data()
	Debug.log(response)
	fact.text = response.fact
	
