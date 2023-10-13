

let StockChannelTest = {
    init(socket) {

        
        let channel = socket.channel(`stocks:listed_stocks`, {})
        channel.join()
        console.log(channel)
        this.listenForPushes(channel)
  
  
    },

    listenForPushes(channel) {
        channel.on(`new_category_stock`, payload => {
          console.log("new order here", payload)
        })
      },
}

export default StockChannelTest
