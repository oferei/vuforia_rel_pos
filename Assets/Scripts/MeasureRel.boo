import UnityEngine

class MeasureRel (MonoBehaviour): 

	public target1 as Transform
	public target2 as Transform
	public posFactor as single = 1.0
	public locations as (Vector3)
	public maxDistance as Vector3
	public cube as Transform

	public colors as (Color)

	def Update ():
		target1Tracked = isTracked(target1.gameObject)
		target2Tracked = isTracked(target2.gameObject)
		# Debug.Log("Anchor enabled: ${target1Tracked}; Token enabled: ${target2Tracked}")

		pos = 0

		if target1Tracked and target2Tracked:
			target2Pos = target2.position / posFactor
			relPos = target1.InverseTransformPoint(target2Pos)
			# relPos = target1.InverseTransformDirection(target2Pos - target1.position)

			for i in range(len(locations)):
				if isInRange(relPos, locations[i]):
					pos = i + 1
					# Debug.Log("In position: pos=${pos}")
					break

			Debug.Log("pos1=${target1.position} pos2=${target2Pos} relPos=${relPos} dist=${Vector3.Distance(target1.position, target2Pos)} pos=${pos}")

		cube.renderer.material.color = colors[pos]

	def isTracked(obj as GameObject):
		for comp as Renderer in obj.GetComponentsInChildren[of Renderer](true):
			return comp.enabled
		for comp as Collider in obj.GetComponentsInChildren[of Collider](true):
			return comp.enabled
		Debug.LogError("Indicative component not found", obj)
		raise System.Exception("Indicative component not found")

	def isInRange(pos1 as Vector3, pos2 as Vector3):
		dist = pos2 - pos1
		return Mathf.Abs(dist.x) < maxDistance.x and Mathf.Abs(dist.y) < maxDistance.y and Mathf.Abs(dist.z) < maxDistance.z
