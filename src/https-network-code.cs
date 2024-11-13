        /// <summary>
        /// Request to fetch current room settings
        /// </summary>
        /// <returns></returns>
        public async Task PairRoom()
        {

            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("secret", Constants.secret);
            package.Add("command", "GET_STATUS");

            controller.UiVariables.Message = "Loading..";

            string response = "X";
            while (response == "X")
                 response = await SendPostRequest(package);

            if (response != null)
            {
                controller.UiVariables.Message = "Loading...";

                handlers.PairRoomHandler(response);


            }

        }

        /// <summary>
        /// send request to control the TV
        /// </summary>
        /// <param name="act">
        /// On: Turn TV Off or On
        /// Up: Turn TV Channel Up
        /// Down: Turn TV Channel Down
        /// </param>
        /// <returns></returns>
        public async Task TVControls(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.On:
                     package.Add("command", "TV_POWER");                                    //tv power on/off
                    break;
                case Actions.Up:
                    package.Add("command", "TV_CH_UP");     //tv channel up
                    break;
                case Actions.Down:
                    package.Add("command", "TV_CH_DN");    //tv channel down
                    break;
            }

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// Change channel on TV directly
        /// Same as pressing number on remote, two needed to actually change channel
        /// </summary>
        /// <param name="newChannel">(INT) channel to turn to</param>
        /// <returns></returns>
        public async Task TVChannel(int newChannel)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            package.Add("command", "TV_CH" + newChannel.ToString());                           //Change TV Input Source to AUX Port

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// Change volume on either TV or Soundbar
        /// </summary>
        /// <param name="act">
        /// Up: Volume Up
        /// Down: Volume Down
        /// Off: Mute/Unmute volume</param>
        /// <param name="device">(string) 
        /// "TV": change TV volume
        /// "SBAR": change soundbar volume</param>
        /// <returns></returns>
        public async Task Volume(Actions act, string device)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            StringBuilder command = new StringBuilder();


            switch (device)
            {
                case "TV":                                                //Soundbar volume up                     
                    command.Append("SBAR_");
                    break;
                case "SBAR":                                              //Soundbar volume down
                    command.Append("SBARD_");
                    break;
            }

            switch (act)
            {
                case Actions.Up:                                               //Mute/Unmute  Soundbar  
                    command.Append("VOL_UP");
                    break;
                case Actions.Down:                                               //Mute/Unmute  Soundbar  
                    command.Append("VOL_DN");
                    break;
                case Actions.Off:
                    if (device.CompareTo("SBAR") == 0)
                        command.Append("VOL_MUTE");
                    else
                        command.Append("VOL_MUTE_BP");
                    break;
            }

            package.Add("command", command.ToString());

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Change TV input
        /// </summary>
        /// <param name="preset">(int)
        /// 1: Use Apple TV
        /// 2: Use Cable
        /// 3: Use bedside HDMI port</param>
        /// <returns></returns>
        public async Task TVInput(int preset)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (preset)
            {
                case 1:
                    package.Add("command", "TV_SOURCE_CAST");                           //Change TV Input Source to Chromecast
                    break;
                case 2:
                    package.Add("command", "TV_SOURCE_CABLE");                            //Change TV Input Source to Cable box
                    break;
                case 3:
                    package.Add("command", "TV_SOURCE_HDMI");                            //Change TV Input Source to AUX Port
                    break;
            }

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// control Apple TV, Emulates remote
        /// </summary>
        /// <param name="type">(int)
        /// 0: Select/OK button
        /// 1: Arrow circle Up button
        /// 2: Arrow circle Down button
        /// 3: Arrow circle Left button
        /// 4: Arrow circle Right button
        /// 5: Play/Pause button
        /// 6: Menu button</param>
        /// <returns></returns>
        public async Task ControlApple(int type)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (type)
            {
                case 0:
                    package.Add("command", "ATV_SELECT");
                    break;
                case 1:
                    package.Add("command", "ATV_UP");
                    break;
                case 2:
                    package.Add("command", "ATV_DOWN");
                    break;
                case 3:
                    package.Add("command", "ATV_LEFT");
                    break;
                case 4:
                    package.Add("command", "ATV_RIGHT");
                    break;
                case 5:
                    package.Add("command", "ATV_PLAY");
                    break;
                case 6:
                    package.Add("command", "ATV_MENU");
                    break;
            }

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// Change input source on soundbar
        /// </summary>
        /// <param name="preset">(int)
        /// 1: TV Audio
        /// 2: Bluetooth conencted source</param>
        /// <returns></returns>
        public async Task SoundbarInput(int preset)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (preset)
            {
                case 1:
                    package.Add("command", "SBAR_VOL_TV");
                    break;
                case 2:
                    package.Add("command", "SBAR_VOL_BLUETOOTH");                         
                    break;
            }

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// Send signal to soundbar to start bluetooth pairing process
        /// </summary>
        /// <returns></returns>
        public async Task PairBluetooth()
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            package.Add("command", "SBAR_PAIR");

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Control Ambient lights array in room
        /// </summary>
        /// <param name="act">(Actions)
        /// Off: Turn Lights Off(Setting 0)
        /// On: Turn Lights On(Previous Setting)
        /// Up: Turn up Lights intensity(Max 10)
        /// Down: Turn Down Lights intensity(Min 0)</param>
        /// <returns></returns>
        public async Task ALights(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Off:
                    package.Add("command", "LTG_OFF_0");                        //Ambient Lights Off
                    break;
                case Actions.On:
                    package.Add("command", "LTG_ON_0");                      
                    break;
                case Actions.Up:
                    package.Add("command", "LTG_DIM_0_RAISE");                      
                    break;
                case Actions.Down:
                    package.Add("command", "LTG_DIM_0_LOWER");
                    break;
            }

            Console.WriteLine(DateTime.Now.ToString() + ": Request Sent");

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);


        }

        /// <summary>
        /// Control Entrance lights array in room
        /// </summary>
        /// <param name="act">(Actions)
        /// Off: Turn Lights Off(Setting 0)
        /// On: Turn Lights On(Previous Setting)
        /// Up: Turn up Lights intensity(Max 10)
        /// Down: Turn Down Lights intensity(Min 0)</param>
        /// <returns></returns>
        public async Task ELights(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Off:
                    package.Add("command", "LTG_OFF_1");
                    break;
                case Actions.On:
                    package.Add("command", "LTG_ON_1");
                    break;
                case Actions.Up:
                    package.Add("command", "LTG_DIM_1_RAISE");
                    break;
                case Actions.Down:
                    package.Add("command", "LTG_DIM_1_LOWER");
                    break;
            }

            Console.WriteLine(DateTime.Now.ToString() + ": Request Sent");

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);



        }

        /// <summary>
        /// Control Reading lights array in room
        /// </summary>
        /// <param name="act">(Actions)
        /// Off: Turn Lights Off(Setting 0)
        /// On: Turn Lights On(Previous Setting)
        /// Up: Turn up Lights intensity(Max 10)
        /// Down: Turn Down Lights intensity(Min 0)</param>
        /// <returns></returns>
        public async Task RLights(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Off:
                    package.Add("command", "LTG_OFF_2");
                    break;
                case Actions.On:
                    package.Add("command", "LTG_ON_2");
                    break;
                case Actions.Up:
                    package.Add("command", "LTG_DIM_2_RAISE");
                    break;
                case Actions.Down:
                    package.Add("command", "LTG_DIM_2_LOWER");
                    break;
            }

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);


        }

        /// <summary>
        /// Send Tutorial log to server
        /// </summary>
        /// <param name="startPage">(string)
        /// Tutorial Page that was clicked</param>
        /// <returns></returns>
        public async Task LogTutorial(string startPage)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "5");

            package.Add("auth", RoomState.getToken());

            package.Add("command", startPage+" Tutorial Started");

            var response = await SendPostRequest(package);
        }


        /// <summary>
        /// Send Survey Log to server
        /// </summary>
        /// <param name="type">(string) 
        /// Type of survey that was completed</param>
        /// <returns></returns>
        public async Task LogSurvey(string type)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "6");

            package.Add("auth", RoomState.getToken());

            package.Add("command", type);

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Control Exam lights array in room
        /// </summary>
        /// <param name="act">(Actions)
        /// Off: Turn Lights Off(Setting 0)
        /// On: Turn Lights On(Previous Setting)
        /// Up: Turn up Lights intensity(Max 10)
        /// Down: Turn Down Lights intensity(Min 0)</param>
        /// <returns></returns>
        public async Task ExLights(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Off:
                    package.Add("command", "LTG_OFF_4");                        //Exam Lights Off
                    break;
                case Actions.On:
                    package.Add("command", "LTG_ON_4");
                    break;
                case Actions.Up:
                    package.Add("command", "LTG_DIM_4_RAISE");
                    break;
                case Actions.Down:
                    package.Add("command", "LTG_DIM_4_LOWER");
                    break;
            }

            Console.WriteLine(DateTime.Now.ToString() + ": Request Sent");

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);



        }

        /// <summary>
        /// Control Bathroom lights array in room
        /// </summary>
        /// <param name="act">(Actions)
        /// Off: Turn Lights Off(Setting 0)
        /// On: Turn Lights On(Previous Setting)
        /// Up: Turn up Lights intensity(Max 10)
        /// Down: Turn Down Lights intensity(Min 0)</param>
        /// <returns></returns>
        public async Task BathLights(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Off:
                    package.Add("command", "LTG_OFF_3");                        //Bathroom Lights Off
                    break;
                case Actions.On:
                    package.Add("command", "LTG_ON_3");
                    break;
                case Actions.Up:
                    package.Add("command", "LTG_DIM_3_RAISE");
                    break;
                case Actions.Down:
                    package.Add("command", "LTG_DIM_3_LOWER");
                    break;
            }

            Console.WriteLine(DateTime.Now.ToString() + ": Request Sent");

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);


        }


        /// <summary>
        /// Change all lights to a preset setting
        /// </summary>
        /// <param name="preset">(int)
        /// 0: Dark setting
        /// 1: Full setting
        /// 2: Reading setting
        /// 3: Soft setting
        /// 4: Watch TV setting</param>
        /// <returns></returns>
        public async Task LightsPreset(int preset)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (preset)
            {
                case 0:
                    package.Add("command", "LTG_DARK");                                  //All Lights Off
                    break;
                case 1:
                    package.Add("command", "LTG_FULL");                                      //All Lights On
                    break;
                case 2:
                    package.Add("command", "LTG_READ");                                 //Reading Preset
                    break;
                case 3:
                    package.Add("command", "LTG_SOFT");                                   //Soft Preset
                    break;
                case 4:
                    package.Add("command", "LTG_TV");                                 //TV Preset
                    break;
            }

            Console.WriteLine(DateTime.Now.ToString() + ": Request Sent");

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);


        }


        /// <summary>
        /// Control Blackout Blinds
        /// </summary>
        /// <param name="act">(Actions)
        /// Open: Open blinds completly
        /// Up: Raise blinds one step
        /// Down: Lower blinds one step
        /// Close: Close blinds completly</param>
        /// <returns></returns>
        public async Task BBlinds(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            { 
                case Actions.Open:
                    package.Add("command", "BLINDS_BLKOUT_OPEN");                        //Open Blackout Blinds all the way
                    break;
            case Actions.Up:
                    package.Add("command", "BLINDS_BLKOUT_UP_1");                         //Raise Blackout Blinds up a bit
                    break;
            case Actions.Down:
                    package.Add("command", "BLINDS_BLKOUT_DOWN_1");                       //Lower Blackout Blinds down a bit
                    break;
            case Actions.Close:
                    package.Add("command", "BLINDS_BLKOUT_CLOSE");                       //Close Blackout Blinds all the way
                    break;
            }

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Control Opaque Blinds
        /// </summary>
        /// <param name="act">(Actions)
        /// Open: Open blinds completly
        /// Up: Raise blinds one step
        /// Down: Lower blinds one step
        /// Close: Close blinds completly</param>
        /// <returns></returns>
        public async Task IBlinds(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Open:
                    package.Add("command", "BLINDS_OPAQUE_OPEN");                        //Open Blackout Blinds all the way
                    break;
                case Actions.Up:
                    package.Add("command", "BLINDS_OPAQUE_UP_1");                         //Raise Blackout Blinds up a bit
                    break;
                case Actions.Down:
                    package.Add("command", "BLINDS_OPAQUE_DOWN_1");                       //Lower Blackout Blinds down a bit
                    break;
                case Actions.Close:
                    package.Add("command", "BLINDS_OPAQUE_CLOSE");                       //Close Blackout Blinds all the way
                    break;
            }

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Control Door
        /// </summary>
        /// <param name="act">(Actions)
        /// Open: Completly open door
        /// Close: Close the door
        /// Partial: Partially open the door</param>
        /// <returns></returns>
        public async Task Door(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Open:
                    package.Add("command", "DOOR_OPEN");//Open Door
                    break;
                case Actions.Close:
                    package.Add("command", "DOOR_CLOSE");//Close Door
                    break;
                case Actions.Partial:
                    package.Add("command", "DOOR_OPEN_PARTIAL");//Open Door Partially
                    break;
            }

            var response = await SendPostRequest(package);
        }

        /// <summary>
        /// Control Thermostat setting
        /// </summary>
        /// <param name="act">(Actions)
        /// Up: Turn Temperature Up(Max 75)
        /// Down: Turn Temperature Down(Min 65)</param>
        /// <returns></returns>
        public async Task Temperature(Actions act)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (act)
            {
                case Actions.Up:
                    if (RoomState.GetSettingTemp() < Constants.maxTemp)         //Turn Temperature Up
                        package.Add("command", "HVAC_TEMP_UP");
                    else
                        return;
                    break;
                case Actions.Down:
                    if (RoomState.GetSettingTemp() > Constants.minTemp)         //Turn Temperature Down
                        package.Add("command", "HVAC_TEMP_DN");
                    else
                        return;
                    break;
            }

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);


        }

        /// <summary>
        /// Call the nurse for Non-emergency
        /// </summary>
        /// <param name="requestType">(string) Type of request </param>
        /// <returns></returns>
        public async Task CallNurse(string requestType)
        {
            var package = new Dictionary<string, string>();

            package.Add("identifier", "OBGYN");
            package.Add("message", requestType);
            package.Add("secret", Constants.secret);

            string responce = await SendPostRequest(package);

            if (responce.Contains("successful"))
            {
                controller.DisableNurse();
            }
        }

        /// <summary>
        /// Control brightness of clock
        /// </summary>
        /// <param name="mode">(int)
        /// 0: Turn clock Off
        /// 1: Turn clock brightness to lowest setting
        /// 2: Turn clock brightness to middle setting
        /// 3: Turn clock brightness to highest setting</param>
        /// <returns></returns>
        public async Task ClockControl(int mode)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (mode)
            {
                case 0:
                    package.Add("command", "CLOCKBRIGHTNESS%OFF");
                    break;
                case 1:
                    package.Add("command", "CLOCKBRIGHTNESS%LOW");
                    break;
                case 2:
                    package.Add("command", "CLOCKBRIGHTNESS%MEDIUM");
                    break;
                case 3:
                    package.Add("command", "CLOCKBRIGHTNESS%HIGH");
                    break;
            }

            var response = await SendPostRequest(package);

            string[] objects = response.Split('\"');

            RoomState.addToList(objects[21]);

            handlers.incomingHttpResponse(objects[21]);
        }

        /// <summary>
        /// Summon and control elevator
        /// </summary>
        /// <returns></returns>
        public async Task Elevator()
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            package.Add("command", "ELEVATORCALL%" + RoomState.GetRoomNumber() + "%" + RoomState.GetElevOriginFloor() +
               "%" + RoomState.GetElevDestFloor() + "%" + RoomState.GetElevBank());

            var response = await SendPostRequest(package);

        }

        /// <summary>
        /// Change brightness of Digital Whiteboard
        /// </summary>
        /// <param name="mode">(int)
        /// 0: Turn Digital Whiteboard Off
        /// 1: Change Whiteboard brightess to "Low"
        /// 2: Change Whiteboard brightness to "High"</param>
        /// <returns></returns>
        public async Task DisplayControl(int mode)
        {
            var package = new Dictionary<string, string>();

            package.Add("roomNum", RoomState.GetRoomNumber().ToString());
            package.Add("roomPin", RoomState.GetRoomPin().ToString());
            package.Add("messageType", "1");

            package.Add("auth", RoomState.getToken());

            switch (mode)
            {
                case 0:
                    package.Add("command", "WB_POWER");                                   //Info Board Power On/Off
                    break;
                case 1:
                    package.Add("command", "WB_DIM");                                     //Dim Info Board
                    break;
                case 2:
                    package.Add("command", "WB_BRIGHT");                                  //Brighten Info Board
                    break;
            }

            var response = await SendPostRequest(package);
        }


 public async Task<string> SendPostRequest(object values)
 {
     HttpClient httpClient;

     var clienthandler = new HttpClientHandler
     {
         ClientCertificateOptions = ClientCertificateOption.Automatic
     };

     httpClient = new HttpClient(clienthandler);

     if (RoomState.haveToken())
         httpClient.DefaultRequestHeaders.Add("authorization", RoomState.getToken());

     clienthandler.ServerCertificateCustomValidationCallback = (sender, cert, chain, sslPolicyErrors) => {

         if (cert.SubjectName.Name == "CN=th-smartroomsip-d1.med.utah.edu, O=University of Utah, S=Utah, C=US")
             return true;

         return false;
     };

     string json = JsonConvert.SerializeObject(values);
     var content = new StringContent(json, Encoding.UTF8, "application/json");
     try
     {
         var response = await httpClient.PostAsync(Constants.HttpServer, content);

         return await response.Content.ReadAsStringAsync();
     }
     catch (Exception ex)
     {
         Console.WriteLine ("Error sending Pair Request: " + ex.Message+ " , retrying");

         return "X";
     }
     return null;
 }


public enum Actions
{
    Off = 0,
    On = 1,
    Up = 2,
    Down = 3,
    Open = 4,
    Close = 5,
    Partial = 6
}