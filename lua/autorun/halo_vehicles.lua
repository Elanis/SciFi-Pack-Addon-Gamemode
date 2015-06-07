//Halo Vehicles

local Category = "Halo"

local V = { 	
				// Required information
				Name = "Rocket Warthog", 
				Class = "prop_vehicle_jeep_old",
				Category = Category,

				// Optional information
				Author = "Athos",
				Information = "Rocket Warthog!!",
				Model = "models/rocketwarthog.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test.txt"
							}
			}

list.Set( "Vehicles", "rocketwarthog", V )