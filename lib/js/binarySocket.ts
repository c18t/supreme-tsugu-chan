import zlib from "zlib"
import msgpack5 from "msgpack5"
const msgpack = msgpack5();

/*lots of console.log() statements for educational purposes in this file, don't forget to remove them in production*/

function convertToBinary(socket: any){

  let parentOnConnOpen = socket.onConnOpen;

  socket.onConnOpen = function() {
    //setting this to arraybuffer will help us not having to deal with blobs
    this.conn.binaryType = 'arraybuffer';
    parentOnConnOpen.apply(this, arguments);
  }

  //we also need to override the onConnMessage function, where we'll be checking
  //for binary data, and delegate to the default implementation if it's not what we expected
  let parentOnConnMessage = socket.onConnMessage;

  socket.onConnMessage = async function (rawMessage: any){
    if(!(rawMessage.data instanceof ArrayBuffer)){
      return parentOnConnMessage.apply(this, rawMessage);
    }
    let msg = await decodeMessage(rawMessage.data) as any;
    let topic = msg.topic;
    let event = msg.event;
    let payload = msg.payload;
    let ref = msg.ref;

    this.log("receive", (payload.status || "") + " " + topic + " " + event + " " + (ref && "(" + ref + ")" || ""), payload);
    this.channels.filter(function (channel: any) {
      return channel.isMember(topic);
    }).forEach(function (channel: any) {
      return channel.trigger(event, payload, ref);
    });
    this.stateChangeCallbacks.message.forEach(function (callback: Function) {
      return callback(msg);
    });
  }

  return socket;
}

async function decodeMessage(rawdata: any){  
  if(!rawdata){
    return;
  }

  let binary = new Uint8Array(rawdata);
  let data;
  //check for gzip magic bytes
  if(binary.length > 2 && binary[0] === 0x1F && binary[1] === 0x8B){
    data = await new Promise((resolve) => zlib.gunzip(binary as Buffer, (e, result) => { resolve(result) })) as Uint8Array;
    console.log('received', binary.length, 'Bytes of gzipped data,', data.length, 'Bytes after inflating');
  }
  else{
    console.log('received', binary.length, 'Bytes of plain msgpacked data');
    data = binary;
  }
  let msg = toMessage(msgpack.decode(data as Buffer));
  return msg;
}

function toMessage(data: Array<any>) {
  return {
    join_ref: data[0],
    ref: data[1],
    topic: data[2],
    event: data[3],
    payload: data[4]
  }
}

export default {  
  convertToBinary
}