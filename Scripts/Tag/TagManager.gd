extends Node

var dict : Dictionary
#노드 오브젝트(key) : 딕셔너리(문자열 : 카운트)

func get_tags(node : Node)-> PackedStringArray:
	#노드가 가지고 있는 태그 반환
	if dict.has(node):
		return dict[node].keys()
	#없으면 새 딕셔너리 반환
	return PackedStringArray()

#노드에 태그가 붙은 횟수 반환
func get_tag_count(node : Node, tag : String)-> int:
	if has_tag(node,tag):
		return dict[node][tag]
	#없으면 0 반환
	return 0

#단일 태그 추가
func add_tag(node : Node, tag : String) -> void:
	#태그가 1개 이상 있을 경우
	if dict.has(node):
		var tags = dict[node] as Dictionary
		#태그를 가지고 있을 경우 count 1 추가
		if tags.has(tag):
			tags[tag]+=1
			return
		#태그 추가
		tags[tag] = 1
	else:
		#없으면 태그 딕셔너리 추가
		var arr = { tag : 1}
		dict[node] = arr

func add_tags(node : Node, tags : PackedStringArray):
	for tag in tags:
		add_tag(node,tag)

#태그 트리 추가(.으로 구분해서 상위부터 하위태그까지 전부 추가)
func add_tag_tree(node : Node, tag : String):
	#해당 태그를 각 태그 부분으로 분류
	var tag_tree = tag.split(".",true)
	
	#상위 태그부터 .하위태그 추가
	var lower_tag = tag_tree[0]
	tag_tree.remove_at(0)
	add_tag(node,lower_tag)
	for str in tag_tree:
		lower_tag += "." + str
		add_tag(node,lower_tag)

#단일 태그 제거 성공 시 true 실패 시 false
func remove_tag(node : Node, tag : String) -> bool:
	if dict.has(node):
		var tags = dict[node] as Dictionary
		#태그가 있으면 제거
		tags.erase(tag)
		#print(tags)
		return true
	return false

#태그 제거 시 하위 태그도 동시에 제거(하위 태그는 상위태그.태그로 구분)
#하위 태그 삭제 시 상위태그를 동시에 작성 요망(상위태그.하위태그)
func remove_tag_tree(node : Node, tag : String) -> bool:
	#시작 태그가 있으면 삭제 없으면 반환
	if !remove_tag(node,tag):
		return false
	var tags = dict[node] as Dictionary
	#상위태그 존재시 모든 태그 순회 후 하위태그 삭제
	for str in tags.keys():
		var upper_tag = tag + "."
		#해당 태그가 상위태그로 시작하면 제거
		if str.begins_with(upper_tag):
			remove_tag(node,str)
	return true
	

#해당 태그가 있는지 확인
func has_tag(node : Node, tag : String) -> bool:
	#해당 노드가 태그가 없을 경우 false 반환
	if !dict.has(node):
		return false
	var tags = dict[node] as Dictionary
	#찾는 태그가 있을 경우 true 반환
	if tags.has(tag):
		return true
	#태그가 없으면 false
	return false


#태그의 카운트 1 감소. 0이면 태그 삭제(아직 사용처 없음, 생기면 변형 예정)
func decrease_tag(node : Node, tag : String) -> void:
	if !dict.has(node):
		return
	var tags = dict[node] as Dictionary
	if !tags.has(tag):
		return
	tags[tag] -=1
	if tags[tag] <=0 :
		remove_tag_tree(node,tag)
	