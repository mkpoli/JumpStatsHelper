// TODO: FFS How to stop the fucking line when you're not jumping.

// TODO: Locallize Console Output

#include <sourcemod>
#include <sdktools>

#define VERSION "0.0.0.1"

public Plugin:myinfo =
{
	name = "KZ Jumpstats Practise Helper",
	author = "mkpoli",
	description = "Help improve your jumpstats.",
	version = VERSION,
	url = ""
}

new g_Beam;
new Float:g_fLastPosition[MAXPLAYERS + 1][3];
new bool:g_bOnGround[MAXPLAYERS+1];

public void OnPluginStart()
{
	// KZTimer Check
	// PrintToServer("KZTimer Loaded");
	
	RegConsoleCmds();
	RegServerConVars();
}

public void OnMapStart()
{
	g_Beam = PrecacheModel("materials/sprites/purplelaser1.vmt", true);
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2]) 
{
	if (GetEntityFlags(client) & FL_ONGROUND)
		g_bOnGround[client]=true;
	else
		g_bOnGround[client]=false;

	decl Float:origin[3];
	GetClientAbsOrigin(client, origin);
	DrawPreStrafeBeam(client, origin);
	g_fLastPosition[client] = origin;
}

public void DrawPreStrafeBeam(client, Float:origin[3])
{
	if(!g_bOnGround[client])
		return;
	new Float:v1[3], Float:v2[3];
	v1[0] = origin[0];
	v1[1] = origin[1];
	v1[2] = origin[2];	
	v2[0] = g_fLastPosition[client][0];
	v2[1] = g_fLastPosition[client][1];
	v2[2] = origin[2];	
	TE_SetupBeamPoints(v1, v2, g_Beam, 0, 0, 0, 2.5, 3.0, 3.0, 10, 0.0, {255, 255, 255, 100}, 0);
	TE_SendToClient(client);
}

public Action:Client_JS(client, args)
{
	PrintToConsole(client, "Jumpstats showed.");
	

	return Plugin_Handled;
}

public Action:Client_JSHelper(client, args)
{
	// TODO: Show menu
	return Plugin_Handled;
}

public RegConsoleCmds()
{
	RegConsoleCmd("sm_jshelper", Client_JSHelper, "Display Jumpstats helper Menu.");
	RegConsoleCmd("sm_js", Client_JS, "Display Jumpstats.")
}

public RegServerConVars()
{
}
 
