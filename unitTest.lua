module(..., package.seeall)

function test_exit()
	local t = {}
	local hitCallback = false
	function t.onPlayingExit(event)
		hitCallback = true
	end
	machine:addState("idle", {exit = t.onPlayingExit})
	machine:addState("playing", {from="*"})
	machine:setInitialState("idle")
	machine:changeState("playing")
	assert_true(hitCallback, "Never called onPlayingExit.")
end