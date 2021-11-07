DefenderBST = class(Behaviour)

function DefenderBST:Name()
	return "DefenderBST"
end

function DefenderBST:Update()
	local f = game:Frame()
	if f % 43 ~= 0 then
		return
	end
	for px,t in pairs(self.ai.targethst.cells)do
		for pz,cell in pairs(t)do

			print(cell)
			if self.ai.tool:Distance(cell.pos , self.ai.defenderhst.CENTER) < self.ai.defenderhst.distal then
				self.unit:Internal():Move(cell.pos)
			end
		end
	end



end
