import * as Location from "expo-location";
import * as TaskManager from "expo-task-manager";
import {festival} from "./festival";
import {distanceMeters} from "./geo";
export const LOCATION_TASK="haptic-quest-proximity";
TaskManager.defineTask(LOCATION_TASK,({data,error})=>{if(error||!data)return;const loc=(data as {locations:Location.LocationObject[]}).locations.at(-1);if(!loc)return;const distances=festival.checkpoints.map(c=>({id:c.id,d:distanceMeters(loc.coords.latitude,loc.coords.longitude,c.lat,c.lon)})).sort((a,b)=>a.d-b.d);const nearest=distances[0];if(nearest&&nearest.d<120){/* Deliberately no raw-coordinate persistence or network upload. UI foreground provides haptic cues. */}});
export async function enableBackgroundProximity(){const fg=await Location.requestForegroundPermissionsAsync();if(fg.status!=="granted")return false;const bg=await Location.requestBackgroundPermissionsAsync();if(bg.status!=="granted")return false;await Location.startLocationUpdatesAsync(LOCATION_TASK,{accuracy:Location.Accuracy.Balanced,distanceInterval:30,timeInterval:15000,pausesUpdatesAutomatically:true,foregroundService:{notificationTitle:"Haptic Quest active",notificationBody:"Using on-device proximity for your active festival quest."}});return true}
export async function disableBackgroundProximity(){if(await Location.hasStartedLocationUpdatesAsync(LOCATION_TASK))await Location.stopLocationUpdatesAsync(LOCATION_TASK)}
