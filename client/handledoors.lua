
DoorList = {
	"lapdoors-firstlapdoor",
	"lapdoors-secondlapdoor",
	"lapdoors-thirdlapdoor",
	'lapdoors-fourthlapdoor',
	'lapdoors-fifthlapdoor',
	'lapdoors-sixthlapdoor',
	'lapdoors-seventhlapdoor',
	'lapdoors-eigththlapdoor',
	'lapdoors-ninethlapdoor',
	'lapdoors-tenthlapdoor',
	'lapdoors-elevenlapdoor',
	'lapdoors-tewelvthlapdoor',
	'lapdoors-therteenthlapdoor',
}


RegisterNetEvent('Diesel-lapheist:Client:SetDoorsOpenedState', function (state)
    for i, v in pairs (DoorList) do 
        TriggerServerEvent('qb-doorlock:server:updateState', v, state, false, false, true)
    end
end)
