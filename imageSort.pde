

PImage b;
int pixelCount;
String targetImage = "death_Original.jpg";
//String targetImage = "l.jpeg";
//String targetImage = "test.jpeg";
PImage outputImage;
final String outputFormat =".tiff";
String baseName;
final int numberOfSorts=5;


//--------------------------------------------------
//main functions
void setup() {
	b = loadImage(targetImage); 
	size(b.width,b.height);
	pixelCount=b.width*b.height;
	// printImageHexValues();

	outputImage = basicSort(b);
	//PROBLEM these three act identically
	//outputImage = powerAddSort(b);
	//outputImage = byteHashSort(b);
	

       
        //outputImage = powerMultiplySort(b);

	//outputImage = powerMultiplyRowSort(b);

	baseName=targetImage.substring(0,targetImage.indexOf("."));

	noLoop();	// Makes draw() only run once
}


void draw(){

	image( outputImage, 0, 0);

	saveFrame(baseName+"_sort-####"+outputFormat);

}

//--------------------------------------------------
//utility functions

SortPixelRGBA[] pixelsToSortPixels(color[] p){
	SortPixelRGBA[] spArray = new SortPixelRGBA[pixelCount];
	
	for(int i = 0; i<pixelCount; i++){
		spArray[i] = new SortPixelRGBA(p[i]);
	}
	return spArray;
}

color[] sortPixelsToPixels(SortPixelRGBA[] sp) {
	color[] pArray = new color[pixelCount];
	
	for(int i = 0; i<pixelCount; i++){
		pArray[i] = sp[i].toColor();
	}
	return pArray;
}


PImage newImageFromPixels(color[] pix){

	PImage newImg = createImage(b.width,b.height,RGB);
	newImg.loadPixels();
	setAllPixels(newImg,pix);
	newImg.updatePixels();
	return newImg;

}

void setAllPixels(PImage target, color[] pix) {
	
	for(int i = 0; i<pixelCount; i++){
		target.pixels[i] = pix[i];
	}
	
}

color[][] rowPartition(color[] pix,int h, int w) {
	color[][] rowPix = new color[h][w];
	int count = 0;
	for(int i =0; i<h; i++) {
		for(int j =0; j<w; j++) {
			rowPix[i][j] = pix[count];
			count++;
		}
	}
	return rowPix;
}


SortPixelRGBA[][] rowPartition(SortPixelRGBA[] pix,int h, int w) {
	SortPixelRGBA[][] rowPix = new SortPixelRGBA[h][w];
	int count = 0;
	for(int i =0; i<h; i++) {
		for(int j =0; j<w; j++) {
			rowPix[i][j] = pix[count];
			count++;
		}
	}
	return rowPix;
}

SortPixelRGBA[] dePartition(SortPixelRGBA[][] rows){
	SortPixelRGBA[] sPix = new SortPixelRGBA[rows.length*rows[0].length];
	int count = 0;
	for(int i =0; i<rows.length; i++) {
		for(int j =0; j<rows[0].length; j++) {
			sPix[count]=rows[i][j];
			count++;
		}
	}
	return sPix;
}

public void sortSelector(int i, PImage img){

	
}

//--------------------------------------------------
//quicksort algorithm for SortPixelRGBA

final	int CUTOFF = 3;

public void quicksort( SortPixelRGBA[] a )
{
	quicksort( a, 0, a.length - 1 );
}

	


private	void swapReferences( SortPixelRGBA[] a, int index1, int index2 )
{
	SortPixelRGBA tmp = a[ index1 ];
	a[ index1 ] = a[ index2 ];
	a[ index2 ] = tmp;
}


private	SortPixelRGBA median3( SortPixelRGBA[] a, int left, int right )
{
	int center = ( left + right ) / 2;
	if( a[ center ].compareTo( a[ left ] ) < 0 )
		swapReferences( a, left, center );
	if( a[ right ].compareTo( a[ left ] ) < 0 )
		swapReferences( a, left, right );
	if( a[ right ].compareTo( a[ center ] ) < 0 )
		swapReferences( a, center, right );

		// Place pivot at position right - 1
	swapReferences( a, center, right - 1 );
	return a[ right - 1 ];
}


private	void quicksort( SortPixelRGBA [ ] a, int left, int right )
{
	if( left + CUTOFF <= right )
	{
		SortPixelRGBA pivot = median3( a, left, right );

			// Begin partitioning
		int i = left, j = right - 1;
		for( ; ; )
		{
			while( a[ ++i ].compareTo( pivot ) < 0 ) { }
			while( a[ --j ].compareTo( pivot ) > 0 ) { }
			if( i < j )
				swapReferences( a, i, j );
			else
				break;
		}

		swapReferences( a, i, right - 1 );	// Restore pivot

		quicksort( a, left, i - 1 );	// Sort small elements
		quicksort( a, i + 1, right );	// Sort large elements
	}
	else	// Do an insertion sort on the subarray
		insertionSort( a, left, right );
}

private	void insertionSort( SortPixelRGBA [ ] a, int left, int right )
{
	for( int p = left + 1; p <= right; p++ )
	{
		SortPixelRGBA tmp = a[ p ];
		int j;

		for( j = p; j > left && tmp.compareTo( a[ j - 1 ] ) < 0; j-- )
			a[ j ] = a[ j - 1 ];
		a[ j ] = tmp;
	}
}


//--------------------------------------------------
//sort types

PImage basicSort(PImage img) {
 
	return basicSort(img.pixels);
}


PImage basicSort(color[] pix){
	SortPixelRGBA[] sPixels = pixelsToSortPixels(pix);
	quicksort(sPixels);
	
	pix = sortPixelsToPixels(sPixels);
	
	
	return newImageFromPixels(pix);
}

PImage powerAddSort(PImage img){
	return powerAddSort(img.pixels); 
}

PImage powerAddSort(color[] pix){
	SortPixelRGBA[] sPixels = pixelsToSortPixels(pix);
	
	for(int i = 0; i<sPixels.length; i++) {
		sPixels[i].setSortValue_PowerAdd();	
	}
	quicksort(sPixels);
	pix = sortPixelsToPixels(sPixels);
	return newImageFromPixels(pix);
}

PImage byteHashSort(PImage img){
	return byteHashSort(img.pixels); 
}

PImage byteHashSort(color[] pix){
	SortPixelRGBA[] sPixels = pixelsToSortPixels(pix);
	for(int i = 0; i<sPixels.length; i++) {
		sPixels[i].setSortValue_byteHash();	
	}
	quicksort(sPixels);
	pix = sortPixelsToPixels(sPixels);
	return newImageFromPixels(pix);
}


PImage powerMultiplySort(PImage img){
	return powerMultiplySort(img.pixels); 
}

PImage powerMultiplySort(color[] pix){
	SortPixelRGBA[] sPixels = pixelsToSortPixels(pix);
	
	for(int i = 0; i<sPixels.length; i++) {
		sPixels[i].setSortValue_powerMultiply();	
	}
	
	quicksort(sPixels);
	pix = sortPixelsToPixels(sPixels);
	return newImageFromPixels(pix);
}

PImage powerMultiplyRowSort(color[] pix) {
	SortPixelRGBA[] sPixels = pixelsToSortPixels(pix);
	
	for(int i = 0; i<sPixels.length; i++) {
		sPixels[i].setSortValue_powerMultiply();	
	}
	
	SortPixelRGBA[][] rows = rowPartition(sPixels,b.height,b.width);
	
	for(int i = 0; i<rows.length; i++) {
		quicksort(rows[i]);
	}
	sPixels = dePartition(rows);
	pix = sortPixelsToPixels(sPixels);
	return newImageFromPixels(pix);
}
	
 
PImage powerMultiplyRowSort(PImage img) {
	return powerMultiplyRowSort(img.pixels);
}




//--------------------------------------------------
class SortPixelRGBA{
	
	private	color original;
	private	double r;
	private	double g;
	private	double b;
	private	double a;
	private	double sortValue;
	
	SortPixelRGBA(color c) {
		r =	red(c);
		g =	green(c);
		b =	blue(c);
		a =	alpha(c);
		sortValue= c;
		original= c;
	}
	
	public	void printColorValues() {
		print("["+r+" "+g+" " +b+ " "+ a+"]");
	}
	
	public void printSortValue(){
		print(sortValue);
	}
	

	
	public void setSortValue_PowerAdd() {
		sortValue = r+Math.pow(g,3)+Math.pow(b,6);
	}
	
	public void setSortValue_powerMultiply(){
		sortValue = r*Math.pow(g,3)*Math.pow(b,6);
	}
	
	public void setSortValue_powerMultiplySpecle(){
		sortValue = r*Math.pow(g,2)*Math.pow(b,6);
	}
	
	void setSortValue_byteHash(){
		sortValue =	r+(g*Math.pow(10,3))+(b*Math.pow(10,6));
	}
	
	color toColor() {
		return original;
	}	
	
	int compareTo(SortPixelRGBA other) {

		if(this.sortValue > other.sortValue){
			return 1;
		} else if(this.sortValue == other.sortValue) {
			return 0;
		
		} else{
			return -1;
		}
	}
 }


