var BarCode = React.createClass({
  getInitialState: function () {
    var create_qrcode = function(text, typeNumber, errorCorrectLevel, table) {
      var qr = qrcode(typeNumber || 4, errorCorrectLevel || 'M');
      qr.addData(text);
      qr.make();
      return qr.createImgTag(2);
    };
    return {
      selected: this.props.selected,
      src:create_qrcode(this.props.code, 4)
    };
  },
  onSelectQRCode:function() {
    //this.setState({selected: !this.state.selected})
    AppDispatcher.dispatch({
      action:'setselected',
      code:this.props.code,
      selected:!this.props.selected
    })
  },
  render: function() {
    var qrBoxStyle = {
      align: 'center',
      padding:5,
      margin:2,
      float: 'left'
    };
    if (this.props.selected) {
      qrBoxStyle['backgroundColor'] = 'rgba(0,255,0,0.4)'
    }
    return (
      <div onClick={this.onSelectQRCode} style={qrBoxStyle}>
        <img className="qrImage" src={this.state.src}/>
        <br />
        {this.props.code}
      </div>
    )
}

});
var BarCodes = React.createClass({
  getInitialState: function() {
    var stockRecordsArray = JSON.parse(this.props.stockRecords);
    stockRecordsArray.map(function(s) {
      s.selected = false;
    });
    return {stockRecords: stockRecordsArray};
  },
  selectAll: function() {
    this.state.stockRecords.map(function(s) {
      s.selected = true;
    });
    this.setState({stockRecords: this.state.stockRecords});
  },
  unselectAll: function() {
    this.state.stockRecords.map(function(s) {
      s.selected = false;
    })
    this.setState({stockRecords: this.state.stockRecords});
  },
  printSelected: function() {

  },
  handleEvents: function(e) {
    if (e.action === 'setselected') {
      this.state.stockRecords.map(function(s) {
        if (s.code == e.code) {
          s.selected = e.selected;
          this.setState({stockRecords: this.state.stockRecords});
        }
      }.bind(this))
    }
  },
  componentDidMount: function() {
    this.token = AppDispatcher.register(this.handleEvents);
  },
  componentWillUnmount: function() {
    AppDispatcher.unregister(this.token)
  },
  render: function() {
    var genBarcode = function(stockRecord) {
      return (
        <BarCode key={stockRecord.id} code={stockRecord.code} selected={stockRecord.selected}></BarCode>
      )
    };
    return (
      <div className="row">
        <div className="col-md-12">
          <button className="btn btn-default" onClick={this.selectAll}>全选</button>&nbsp;
          <button className="btn btn-default" onClick={this.unselectAll}>全不选</button>&nbsp;
          <button className="btn btn-default" onClick={this.printSelected}>打印</button>&nbsp;
        </div>
        {this.state.stockRecords.map(genBarcode)}
      </div>
    );
  }
});