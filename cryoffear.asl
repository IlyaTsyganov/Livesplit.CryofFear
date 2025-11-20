
state("cof")
{
    float pausestate: "hw.dll",0x11119E4;
    float loadingstate: "hw.dll",0x10D279C;
    float cutscenestate: "client.dll",0x18ED64;
    string40 map: "hw.dll",0xF1AA15;
    string13 coopstart: "hw.dll",0x377BD8;
    string40 menu_map: "hw.dll",0x820495;
    float igt: "client.dll",0x1BE920;
    string40 music : "client.dll",0x5440C8;
    string40 ambient : "hw.dll",0x72F11B;
    float savestate: "client.dll", 0x18A3E0;
    float hp: "hw.dll",0x116BED0;
    float canmove: "hw.dll",0x9FDC30;
    float alive: "hw.dll", 0x1F39F0;
    float demo: "hw.dll", 0x1F39C8;
    int typeofgame: "combase.dll",0x23EB70;
    float crashstate: "crashhandler.dll",0x5600C;
}

init
{
    vars.flag=1;
    vars.savemap = "";
    vars.maps=0;
    vars.chapters=0;
    //vars.savetime=0;
}

startup
{
    vars.crashtime=0;
    vars.saveflag=0;
    vars.campaign=0;
    vars.TimerModel = new TimerModel { CurrentState = timer };
    settings.Add("Split on map change");
    settings.SetToolTip("Split on map change",
    "Splits whenever the map changes");
    settings.Add("Split on chapter change");
    settings.SetToolTip("Split on chapter change",
    "Splits whenever a chapter is finished");    
    settings.Add("Undo when loading the savefile");
    settings.SetToolTip("Undo when loading the savefile",
    "Undoes as many splits as were made before the loading the savefile (for main campaign only)");
    settings.CurrentDefaultParent = "Split on map change";
    settings.Add("Water glitch");
}

start
{
    vars.lakeskip = false;
    vars.chapter3 = true;
    if((current.map=="c_nightmare.bsp" && current.loadingstate==0)// main campaign
    ||(current.map=="c_doc_city.bsp" && current.loadingstate==0)// doc mode
    ||(current.map=="c_rumpel1.bsp" && current.loadingstate==0 && current.cutscenestate == 0)// memories
    ||(current.map=="c_hallo_iambulletproof.bsp" && current.loadingstate==0 && current.cutscenestate == 0)// halloween collab
    ||(current.map=="c_arvuti.bsp" && current.loadingstate==0 && current.cutscenestate == 0)// community collab
    ||(current.map=="c_the_stairway1.bsp" && current.loadingstate==0)// the stairway
    ||(current.music=="coopstart.mp3"))  
    {
        return true;
    }
}

reset
{
    return ((current.map=="c_nightmare.bsp"||current.map=="c_doc_city.bsp"||current.map=="c_rumpel1.bsp"||current.map=="c_hallo_iambulletproof.bsp"||current.map=="c_arvuti.bsp"||current.map=="c_the_stairway1.bsp")&&old.igt!=0&&current.igt==0)||current.music=="Starting in 3 seconds"||current.map=="c_intro.bsp";//added condition for reset (current.map=="c_intro.bsp")
}

isLoading
{    
    return ((current.pausestate !=0)||(current.loadingstate ==0)
    ||(current.cutscenestate !=0&&current.canmove==0)
    ||(current.cutscenestate !=0&&current.map=="c_subway2st3.bsp")//for some reason you gain control during the cutscene
    ||(current.cutscenestate !=0&&current.map=="c_trainscene.bsp")//for some reason you gain control during the cutscene
    ||(current.menu_map=="c_loadgame.bsp")
    ||(current.menu_map=="c_loadgame.bsp"&&current.loadingstate ==0)
    ||(current.menu_map=="c_difficulty_settings.bsp")
    ||(current.menu_map=="c_game_menu1.bsp")
    ||(current.alive==0&&current.typeofgame==4072));
}

split // added more conditions for splitting
{
    if (old.map=="c_lake.bsp" && current.map=="c_forestday.bsp")
    {
        vars.lakeskip = true;
    }
    if(settings["Split on map change"])
    {
        if((old.map!=current.map
        &&current.map!="c_trainscene.bsp"
        &&current.map!="c_broscene.bsp" 
        &&current.map!="c_intro.bsp"//new
        &&current.map!="c_game_menu1.bsp"
        &&current.map!="cof_campaign_01.bsp"//new
        &&current.map!="c_difficulty_settings.bsp"//new
        &&current.map!="c_loadgame.bsp"//new
        &&current.map!=""//new
        &&old.map!="c_intro.bsp"//new
        &&old.map!="c_game_menu1.bsp"
        &&old.map!="c_difficulty_settings.bsp"//new
        &&old.map!="c_loadgame.bsp"//new
        &&old.map!=""//new
        &&!(settings["Water glitch"] && (current.map=="c_apartment4sick.bsp" || old.map=="c_apartment4sick.bsp"))
        &&!(vars.lakeskip && current.map=="c_forestday.bsp" && old.map=="c_lake.bsp")
        &&!(vars.lakeskip && current.map=="c_lake.bsp" && old.map=="c_forestday.bsp")
        &&current.map!="c_nightmare.bsp"//new
        &&current.map!="c_doc_city.bsp"//new
        &&current.map!="c_rumpel1.bsp"
        &&current.map!="c_hallo_iambulletproof.bsp"
        &&current.map!="c_arvuti.bsp"
        &&current.map!="c_the_stairway1.bsp")
        &&vars.flag==1
       // &&(current.crashstate!=0&&old.crashstate==0)
        ||(current.music=="endmusic1.mp3") // any% ending 1
        ||(current.music=="endmusic2.mp3") // any% ending 2
        ||(current.music=="endmusic3.mp3") // any% ending 3
        ||(current.music=="endmusic4.mp3") // any% ending 4
        ||(current.music=="coopend.mp3") // coop ending
        ||(current.music=="manhunt.mp3") // manhunt ending
        ||(current.music=="lifelover.mp3") //memories
        ||(current.music=="survive_hotel_terror.mp3") //halloween
        ||(current.music=="collab_csong.mp3") //community
        ||(current.map=="c_doc_ending.bsp")) //docmode
        // the stairway uses one of the endmusic mp3s but i just cant be asked to locate which one since it splits anyway
        {
            if(vars.saveflag==1&&vars.flag==1)
            {
                vars.maps+=1;
 
            }
            
            return true;
        }
        else if(old.igt==0&&current.igt>0)
        {
            vars.flag=1;
        }
    }
    else if(settings["Split on chapter change"])
    {
        if(current.map=="c_buscity2.bsp" && old.map=="c_buscity.bsp")
        {
            vars.chapter3 = false;
        }
        if((current.map=="c_basement.bsp" && old.map=="c_apartmentsick.bsp") // chapter 2 transition
        ||(current.map=="c_city.bsp" && old.map=="c_sewer3.bsp") // chapter 3 transition
        ||vars.chapter3 && (current.map=="c_park2.bsp" && old.map=="c_park3.bsp") // chapter 4 transition
        ||(current.map=="c_subway2st1.bsp" && old.map=="c_subwaysick2.bsp") // chapter 5 transition
        ||(current.map=="c_bridge.bsp" && old.map=="c_broscene.bsp") // chapter 6 transition
        ||(current.map=="c_asylum1day.bsp" && old.map=="c_attic.bsp") // chapter 7 transition
        ||(current.music=="endmusic1.mp3") // any% ending 1
        ||(current.music=="endmusic2.mp3") // any% ending 2
        ||(current.music=="endmusic3.mp3") // any% ending 3
        ||(current.music=="endmusic4.mp3")) // any% ending 4
        /*
        ||(old.map!="c_cof_asylumday.bsp" && current.map=="c_cof_campaign_01_p2.bsp") // coop chapter 10 transition
        ||(old.map!="c_cof_bridge.bsp" && current.map=="c_cof_campaign_01_p3.bsp") // coop chapter 11 transition
        ||(old.map!="c_cof_city.bsp" && current.map=="c_cof_campaign_01_p4.bsp") // coop chapter 12 transition
        ||(current.music=="coopend.mp3")) // coop ending 
        */
        {
            return true;
        }
        {
            if (vars.saveflag==1)
            {
                vars.chapters+=1;

            }
        } 
    }
}

gameTime
{

    if (old.savestate!=0 && current.savestate==0&&current.music=="Saved")
    {
        vars.maps=0;
        vars.savemap=current.map;
        vars.saveflag=1;
        //vars.savetime=timer.CurrentTime.GameTime.Value.TotalSeconds;
        vars.crashtime=vars.savetime;
    }   
    
    if((current.menu_map=="c_loadgame.bsp"&&current.loadingstate!=0||current.alive==0||current.map==""&&current.loadingstate==0||current.map=="c_game_menu1.bsp")||(current.crashstate!=0&&old.crashstate==0)&&vars.saveflag==1)
    {   
        if(settings["Split on map change"])
        {
            vars.flag=1;
                    if(vars.maps>=0)
                    {
                        
                        if(settings["Undo when loading the savefile"])
                        {
                            vars.flag=0; 
                            for(int i=0;i<vars.maps;i++)
                            {
                                vars.TimerModel.UndoSplit(); 
                            }
                        } 
                        vars.maps=0;  
                    }    
        }

    else if(settings["Split on chapter change"])
    {
                if(vars.chapters>=0)
                {  
                    if(settings["Undo when loading the savefile"])
                    {
                    for(int i=0;i<vars.chapters;i++)
                    {
                        vars.TimerModel.UndoSplit(); 
                    } 
                    }
                    vars.chapters=0;   
                }
    }   
        //if(vars.savetime==0)
        //{
        //    return TimeSpan.FromSeconds((vars.crashtime));
        //}
        //else
        //{
        //    return TimeSpan.FromSeconds((vars.savetime));
        //}  
        
    }

}
