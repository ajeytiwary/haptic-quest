import { CameraView, useCameraPermissions } from "expo-camera";
import { router, useLocalSearchParams } from "expo-router";
import { useState } from "react";
import { Pressable, SafeAreaView, StyleSheet, Text, View } from "react-native";
import { festival } from "../lib/festival";
import { backendEnabled, verifyCheckpoint } from "../lib/backend";

export default function Scanner(){
 const {checkpoint}=useLocalSearchParams<{checkpoint:string}>();const[permission,requestPermission]=useCameraPermissions();const[locked,setLocked]=useState(false);const[message,setMessage]=useState("");const target=festival.checkpoints.find(x=>x.id===checkpoint);
 async function scanned(data:string){if(!target)return;setLocked(true);try{const u=new URL(data);const token=u.searchParams.get("token")||u.searchParams.get("code");if(u.protocol!=="hapticquest:"||!token)throw new Error("Invalid marker");if(backendEnabled){await verifyCheckpoint(festival.id,target.id,token)}else if(token!==target.code){throw new Error("Invalid demo code")}router.replace({pathname:"/",params:{verified:target.id}})}catch(e){setMessage(e instanceof Error?e.message:"Verification failed");setTimeout(()=>setLocked(false),1200)}}
 if(!permission)return <SafeAreaView style={s.safe}/>;
 if(!permission.granted)return <SafeAreaView style={s.safe}><View style={s.page}><Text style={s.title}>Scan checkpoint</Text><Text style={s.muted}>Camera access is used only while scanning a checkpoint marker.</Text><Pressable style={s.btn} onPress={requestPermission}><Text style={s.bt}>Allow camera</Text></Pressable></View></SafeAreaView>;
 return <SafeAreaView style={s.safe}><CameraView style={StyleSheet.absoluteFill} barcodeScannerSettings={{barcodeTypes:["qr"]}} onBarcodeScanned={locked?undefined:({data})=>scanned(data)}/><View style={s.overlay}><Text style={s.title}>Scan checkpoint</Text><Text style={s.muted}>{target?.name}</Text>{message?<Text style={s.error}>{message}</Text>:null}<Pressable style={s.close} onPress={()=>router.back()}><Text style={s.bt}>Cancel</Text></Pressable></View></SafeAreaView>
}
const s=StyleSheet.create({safe:{flex:1,backgroundColor:"#09090b"},page:{padding:24},overlay:{position:"absolute",left:20,right:20,bottom:40,backgroundColor:"#18181bee",padding:20,borderRadius:20},title:{color:"#fff",fontSize:28,fontWeight:"900"},muted:{color:"#d4d4d8",marginTop:8},error:{color:"#fca5a5",marginTop:8},btn:{backgroundColor:"#fff",padding:14,borderRadius:14,marginTop:20,alignItems:"center"},close:{backgroundColor:"#fff",padding:12,borderRadius:12,marginTop:14,alignItems:"center"},bt:{color:"#111",fontWeight:"900"}});
