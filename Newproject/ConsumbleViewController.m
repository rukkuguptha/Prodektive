//
//  ConsumbleViewController.m
//  Newproject
//
//  Created by GMSIndia1 on 1/1/14.
//  Copyright (c) 2014 GMSIndia1. All rights reserved.
//

#import "ConsumbleViewController.h"

@interface ConsumbleViewController ()

@end

@implementation ConsumbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _consumbleTable.layer.borderWidth = 2.0;
    _consumbleTable.layer.borderColor = [UIColor colorWithRed:234.0/255.0f green:244.0/255.0f blue:249.0/255.0f alpha:1.0f].CGColor;
    _titleView.backgroundColor = [UIColor colorWithRed:234.0/255.0f green:244.0/255.0f blue:249.0/255.0f alpha:1.0f];
    /*searchbar*/
    _searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    _searchbar.delegate = (id)self;
    _searchbar.tintColor=[UIColor colorWithRed:234.0/255.0f green:244.0/255.0f blue:249.0/255.0f alpha:1.0f];
    
    self.consumbleTable.tableHeaderView =_searchbar;
    
    UISearchDisplayController* searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchbar contentsController:self];
    searchController.searchResultsDataSource = (id)self;
    searchController.searchResultsDelegate =(id)self;
    searchController.delegate = (id)self;

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self SelectAllConsumables];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-Popover
-(void)createpopover{
    UIViewController* popoverContent = [[UIViewController alloc]
                                        init];
    
    UIView* popoverView = [[UIView alloc]
                           initWithFrame:CGRectMake(0, 0, 200, 120)];
    
    popoverView.backgroundColor = [UIColor whiteColor];
    _popOverTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, 120)];
    
    _popOverTableView.delegate=(id)self;
    _popOverTableView.dataSource=(id)self;
    _popOverTableView.rowHeight= 32;
    _popOverTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    
    // CGRect rect = frame;
    [popoverView addSubview:_popOverTableView];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(200, 120);
    
    //create a popover controller
    
    self.popOverController = [[UIPopoverController alloc]
                              initWithContentViewController:popoverContent];
    
    //
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    CGRect rect=CGRectMake(cell.bounds.origin.x+90, cell.bounds.origin.y+10, 50, 30);
    //    [self.popOverController presentPopoverFromRect:_disclsurelbl.bounds inView:self.view permittedArrowDirections:nil animated:YES];
    
    
    
    
    
    
    [self.popOverController presentPopoverFromRect:_subsearchbtnlbl.frame
                                            inView:self.addView
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
    
    
}

#pragma mark- WebService
-(void)SelectAllConsumables{
    recordResults = FALSE;
    NSString *soapMessage;
    
    
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<SelectAllConsumables xmlns=\"http://ios.kontract360.com/\">\n"
                   
                   "</SelectAllConsumables>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/SelectAllConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}
-(void)InsertConsumables{
    webtype=1;
    recordResults = FALSE;
    NSString *soapMessage;
    
    
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<InsertConsumables xmlns=\"http://ios.kontract360.com/\">\n"
                   "<itemcode>%@</itemcode>\n"
                   "<description>%@</description>\n"
                   "<subtype>%@</subtype>\n"
                   "<unitcost>%f</unitcost>\n"
                    "</InsertConsumables>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n",_codetxtfld.text,_destxtfld.text,_subtyptxtfld.text,[_unitcosttxtfld.text doubleValue]];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/InsertConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}
-(void)UpdateConsumables{
    webtype=2;
    recordResults = FALSE;
    NSString *soapMessage;
    
    Manpwr*pwrmdl=(Manpwr *)[_cnsumblearray objectAtIndex:butnpath];
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<UpdateConsumables xmlns=\"http://ios.kontract360.com/\">\n"
                   "<entryid>%d</entryid>\n"
                   "<itemcode>%@</itemcode>\n"
                   "<description>%@</description>\n"
                   "<subtype>%@</subtype>\n"
                   "<unitcost>%f</unitcost>\n"
                    "</UpdateConsumables>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n",pwrmdl.entryid,_codetxtfld.text,_destxtfld.text,_subtyptxtfld.text,[_unitcosttxtfld.text doubleValue]];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/UpdateConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}
-(void)DeleteConsumables{
    webtype=3;
    recordResults = FALSE;
    NSString *soapMessage;
    
    Manpwr*pwrmdl=(Manpwr *)[_cnsumblearray objectAtIndex:path];
    
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<DeleteConsumables  xmlns=\"http://ios.kontract360.com/\">\n"
                   "<Entryid>%d</Entryid>\n"
                   "</DeleteConsumables >\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n",pwrmdl.entryid];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/DeleteConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}
-(void)SearchConsumables{
    recordResults = FALSE;
    NSString *soapMessage;
    
    
    
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<SearchConsumables xmlns=\"http://ios.kontract360.com/\">\n"
                   "<searchtext>%@</searchtext>\n"
                   "</SearchConsumables>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n",_searchstring];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/SearchConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}
-(void)SelectAllSubtypeConsumables{
    recordResults = FALSE;
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   
                   
                   "<soap:Body>\n"
                   
                   "<SelectAllSubtypeConsumables xmlns=\"http://ios.kontract360.com/\">\n"
                   "</SelectAllSubtypeConsumables>\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"];
    NSLog(@"soapmsg%@",soapMessage);
    
    
    // NSURL *url = [NSURL URLWithString:@"http://192.168.0.146/link/service.asmx"];
    NSURL *url = [NSURL URLWithString:@"http://ios.kontract360.com/service.asmx"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://ios.kontract360.com/SelectAllSubtypeConsumables" forHTTPHeaderField:@"Soapaction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        _webData = [NSMutableData data];
    }
    else
    {
        ////NSLog(@"theConnection is NULL");
    }
    
}


#pragma mark - Connection
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   	[_webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *  Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"ERROR with theConenction" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [Alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %d", [_webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"xml===== %@",theXML);
	
	
	if( _xmlParser )
	{
		
	}
	
	_xmlParser = [[NSXMLParser alloc] initWithData: _webData];
	[_xmlParser setDelegate:(id)self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
    if (webtype==1||webtype==2||webtype==3) {
        [self SelectAllConsumables];
        webtype=0;
    }
    [_consumbleTable reloadData];
    [_popOverTableView reloadData];
    
    
    
}
#pragma mark-xml parser
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"SelectAllConsumablesResult"])
    {
        _cnsumblearray=[[NSMutableArray alloc]init];
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"EntryId"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"ItemCode"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"Description"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"SubType"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"UnitCost"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    if([elementName isEqualToString:@"SearchConsumablesResult"])
    {
           _cnsumblearray=[[NSMutableArray alloc]init];
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if([elementName isEqualToString:@"SelectAllSubtypeConsumablesResult"])
    {
        _subtypearray=[[NSMutableArray alloc]init];
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
    if([elementName isEqualToString:@"subtype"])
    {
        
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
    
	if( recordResults )
        
	{
        
        
		[_soapResults appendString: string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"EntryId"])
    {
        _Consublemdl=[[Manpwr alloc]init];
        
        recordResults = FALSE;
        
        _Consublemdl.entryid=[_soapResults integerValue];
        _soapResults = nil;
    }
    if([elementName isEqualToString:@"ItemCode"])
    {
        
        recordResults = FALSE;
       _Consublemdl.itemcode=_soapResults;
        
        _soapResults = nil;
    }
    if([elementName isEqualToString:@"Description"])
    {
        
        recordResults = FALSE;
        
         _Consublemdl.itemdescptn=_soapResults;
        _soapResults = nil;
    }
    if([elementName isEqualToString:@"UnitCost"])
    {
        
        recordResults = FALSE;
        
        _Consublemdl.unitcost=_soapResults;
      
        _soapResults = nil;
    }

    if([elementName isEqualToString:@"SubType"])
    {
        
        recordResults = FALSE;
          _Consublemdl.subtype=_soapResults;
          [_cnsumblearray addObject:  _Consublemdl];
        
        _soapResults = nil;
    }
       if([elementName isEqualToString:@"subtype"])
    {
        recordResults = FALSE;
        [_subtypearray addObject:_soapResults];
        _soapResults = nil;
        
        
    }
}


#pragma mark - Table View datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_consumbleTable) {
        return [_cnsumblearray count];
        
    }
    if (tableView==_popOverTableView) {
        return [_subtypearray count];
    }
    return YES;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:12];
        
        if (tableView==_consumbleTable) {
            [[NSBundle mainBundle]loadNibNamed:@"Consumblecell" owner:self options:nil];
            cell=_consumbleCell;
        }
    }
    if (tableView==_popOverTableView) {
        cell.textLabel.text=[_subtypearray objectAtIndex:indexPath.row];
    }
    if (tableView==_consumbleTable) {
        Manpwr*materaialmdl=(Manpwr *)[_cnsumblearray objectAtIndex:indexPath.row];
        _codelbl=(UILabel *)[cell viewWithTag:1];
        _codelbl.text=materaialmdl.itemcode;
        _deslbl=(UILabel *)[cell viewWithTag:2];
        _deslbl.text=materaialmdl.itemdescptn;
        _typelbl=(UILabel *)[cell viewWithTag:3];
        _typelbl.text=materaialmdl.subtype;
        _costlbl=(UILabel *)[cell viewWithTag:4];
        _costlbl.text=materaialmdl.unitcost;
        
    }
    return cell;
}

#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_popOverTableView){
        
        _subtyptxtfld.text=[_subtypearray objectAtIndex:indexPath.row];
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        path=indexPath.row;
        [self DeleteConsumables];
        [_cnsumblearray removeObject:indexPath];
        
        
    }
    
    
}


#pragma mark-Searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _searchstring=_searchbar.text;
    //NSLog(@"search%@",searchstring);
    [self SearchConsumables];
    [_searchbar resignFirstResponder];
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [self SelectAllConsumables];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([_searchbar.text length]==0) {
        
        [self SelectAllConsumables];
        // [searchBar resignFirstResponder];
        
        
    }
    [searchBar resignFirstResponder];
    
    
}

- (IBAction)subsearchbtn:(id)sender{
    [self createpopover];
    [self SelectAllSubtypeConsumables];
    
    
}

- (IBAction)updatebtn:(id)sender{
    if (butntype==1) {
        [self InsertConsumables];
        
    }
    else  if (butntype==2){
        [self UpdateConsumables];
        
    }
}
- (IBAction)cancelbtn:(id)sender{
    _codetxtfld.text=@"";
    
    _destxtfld.text=@"";
    _subtyptxtfld.text=@"";
    _unitcosttxtfld.text=@"";
    
}
- (IBAction)deletebtn:(id)sender{
    butntype=3;
    if (self.editing) {
        [super setEditing:NO animated:NO];
        [_consumbleTable setEditing:NO animated:NO];
        [_consumbleTable reloadData];
        
        
        
    }
    
    else{
        [super setEditing:YES animated:YES];
        [_consumbleTable setEditing:YES animated:YES];
        [_consumbleTable reloadData];
        
        
        
        
    }

    
}


-(IBAction)closeconsume:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)addconsume:(id)sender
{
    _addView.hidden=NO;
    _codetxtfld.text=@"";
    
    _destxtfld.text=@"";
    _subtyptxtfld.text=@"";
    _unitcosttxtfld.text=@"";
    butntype=1;
       _navItem.title=@"ADD";
    
    
}
-(IBAction)editconsume:(id)sender{
     butntype=2;
    button = (UIButton *)sender;
    CGPoint center= button.center;
    CGPoint rootViewPoint = [button.superview convertPoint:center toView:self.consumbleTable];
    NSIndexPath *textFieldIndexPath = [self.consumbleTable indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"textFieldIndexPath%d",textFieldIndexPath.row);
    butnpath=textFieldIndexPath.row;
    Manpwr*toolmdl=(Manpwr *)[_cnsumblearray objectAtIndex:butnpath];
    _codetxtfld.text=toolmdl.itemcode;
    NSLog(@"toolmdl.itemcode%@",toolmdl.itemcode);
    _destxtfld.text=toolmdl.itemdescptn;
    _subtyptxtfld.text=toolmdl.subtype;
    _unitcosttxtfld.text=toolmdl.unitcost;
    
    
    _addView.hidden=NO;
    _navItem.title=@"EDIT";

}

-(IBAction)closeaddview:(id)sender{
    _addView.hidden=YES;
    
}

@end