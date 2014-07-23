import bb.cascades 1.2
import bb.data 1.0

Page {
    content: ListView {
        id: myListView
        
        // Associate the list view with the data model that's defined in the
        // attachedObjects list
        dataModel: dataModel
        
        listItemComponents: [
            ListItemComponent {
                type: "item"
                
                // Use a standard list item to display the data in the data
                // model
                StandardListItem {
                    title: ListItemData.home_team.country + " VS " + ListItemData.away_team.country
                    description: String(ListItemData.datetime).substr(0,10)
                }
            }
        ]
    }
    
    attachedObjects: [
        GroupDataModel { 
            id: dataModel
            
            // Sort the data in the data model by the "pubDate" field, in
            // descending order, without any automatic grouping
            sortingKeys: ["datetime"]
            sortedAscending: true
        },
        DataSource {
            id: dataSource
            source: "http://worldcup.sfg.io/matches"
            type: DataSourceType.Json
            
            onDataLoaded: {
                // After the data is loaded, clear any existing items in the data
                // model and populate it with the new data
                dataModel.clear();
                for (var i = 0; i < data.length; i ++) {
                    var today = new Date();
                    var dateOfEvent = new Date();
                    dateOfEvent.setYear(Number(String(data[i].datetime).substr(0,4)));
                    dateOfEvent.setMonth(Number(String(data[i].datetime).substr(5,2)) - 1);
                    dateOfEvent.setDate(Number(String(data[i].datetime).substr(8,2)));
                    if (today <= dateOfEvent)
                		dataModel.insert(data[i])
                }
            }
        }
    ]
    
    onCreationCompleted: {
        // When the top-level Page is created, direct the data source to start
        // loading data
        dataSource.load();
    }
}