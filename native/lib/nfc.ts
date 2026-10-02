import NfcManager,{NfcTech} from "react-native-nfc-manager";
import {festival} from "./festival";
import {backendEnabled,verifyCheckpoint} from "./backend";
export async function initNfc(){try{await NfcManager.start();return await NfcManager.isSupported()}catch{return false}}
export async function scanNfc(checkpointId:string){const cp=festival.checkpoints.find(x=>x.id===checkpointId);if(!cp)throw new Error("Unknown checkpoint");try{await NfcManager.requestTechnology(NfcTech.Ndef);const tag=await NfcManager.getTag();const record=tag?.ndefMessage?.[0];if(!record?.payload)throw new Error("Empty NFC tag");const bytes=Array.from(record.payload as number[]);const token=new TextDecoder().decode(new Uint8Array(bytes)).replace(/^.../,"").trim();if(backendEnabled)await verifyCheckpoint(festival.id,cp.id,token);else if(token!==cp.code)throw new Error("Invalid demo NFC token");return cp.id}finally{NfcManager.cancelTechnologyRequest().catch(()=>{})}}
