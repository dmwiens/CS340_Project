
function weatherFeature(cityName){

	// When loaded bind the Forms' Submit buttons
	document.addEventListener('DOMContentLoaded', fetchWeather);

	// API key
	var apiKey = 'd6093b7d4cd5781458e0f260efb1d6ba';


	function fetchWeather(){
		
		var req = new XMLHttpRequest();

		var queryString = cityName;
		//var queryString = "San Cristobal de Las Casas, MX";
		req.open("GET", "http://api.openweathermap.org/data/2.5/weather?q=" + queryString + "&appid=" + apiKey, true);
		req.addEventListener('load',function(){
			if (req.status >= 200 && req.status < 400){
				var response = JSON.parse(req.responseText);
				var tempDegF = 9/5*(response.main.temp - 273.15) + 32;
				document.getElementById('cityTemp').textContent = Number(tempDegF).toFixed(2) + ' degrees Fahrenheit';
				} 
			else {
				document.getElementById('cityTemp').textContent = '';
				}
			});

		req.send(null);

	}
}