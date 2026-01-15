class_name Pooler
extends Node

static var singleton: Pooler

var pools: Dictionary[PackedScene, Pool] = {}

func _ready() -> void:
	singleton = self

func enpool_node(node: Node) -> void:
	if !node.is_inside_tree(): return
	
	Scheduler.singleton.enqueue_task(
		func(args: Array):
			var _n = args[0]
			
			if !is_instance_valid(_n):
				return
			
			var n := _n as Node
			
			if !n.is_inside_tree(): return
			n.get_parent().remove_child(n)
			,
		func(_result):
			pass,
		true,
		node
	)
	

func report_free(node: Node) -> void:
	for pool: Pool in pools.values():
		var i := pool.nodes.find(node)
		
		if i == -1: continue
		
		pool.nodes.remove_at(i)
		
	

func dispool_node(scene: PackedScene, parent: Node, finish_callback: Callable) -> void:
	var pool = pools.get(scene) as Pool
	if !pool:
		pool = Pool.new()
		pools[scene] = pool
	
	var node: Node = null
	for key: Node in pool.nodes:
		if !key.is_inside_tree():
			node = key
			break
		
	
	Scheduler.singleton.enqueue_task(
		func(args: Array) -> Node:
			var _po = args[0]
			var _s  = args[1]
			var _pa = args[2]
			var _n  = args[3]
			
			if !_pa: return
			
			var po := _po as Pool
			var s  := _s  as PackedScene
			var pa := _pa as Node
			var n  := _n  as Node
			
			if n && !n.is_inside_tree():
				
				pa.add_child(n)
			else:
				n = s.instantiate()
				pa.add_child(n)
				po.nodes.append(n)
				
			
			return n
			,
		finish_callback,
		true,
		pool,
		scene,
		parent,
		node
	)
	
