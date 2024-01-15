## no critic: Modules::RequireFilenameMatchesPackage
package
    HashDataRole::Sample::DeNiro;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;

around new => sub {
    my $orig = shift;
    $orig->(@_, separator => '::');
};

package HashData::Sample::DeNiro;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'HashDataRole::Source::LinesInDATA';
with 'HashDataRole::Sample::DeNiro';

1;
# ABSTRACT: Movies of Robert De Niro with their year

=head1 SEE ALSO

L<ArrayData::Sample::DeNiro>

L<TableData::Sample::DeNiro>

=cut

__DATA__
Greetings::1968
Bloody Mama::1970
Hi,Mom!::1970
Born to Win::1971
Mean Streets::1973
Bang the Drum Slowly::1973
The Godfather,Part II::1974
The Last Tycoon::1976
Taxi Driver::1976
1900::1977
New York,New York::1977
The Deer Hunter::1978
Raging Bull::1980
True Confessions::1981
The King of Comedy::1983
Once Upon a Time in America::1984
Falling in Love::1984
Brazil::1985
The Mission::1986
Dear America: Letters Home From Vietnam::1987
The Untouchables::1987
Angel Heart::1987
Midnight Run::1988
Jacknife::1989
We're No Angels::1989
Awakenings::1990
Stanley & Iris::1990
Goodfellas::1990
Cape Fear::1991
Mistress::1991
Guilty by Suspicion::1991
Backdraft::1991
Thunderheart::1992
Night and the City::1992
This Boy's Life::1993
Mad Dog and Glory::1993
A Bronx Tale::1993
Mary Shelley's Frankenstein::1994
Casino::1995
Heat::1995
Sleepers::1996
The Fan::1996
Marvin's Room::1996
Wag the Dog::1997
Jackie Brown::1997
Cop Land::1997
Ronin::1998
Great Expectations::1998
Analyze This::1999
Flawless::1999
The Adventures of Rocky & Bullwinkle::2000
Meet the Parents::2000
Men of Honor::2000
The Score::2001
15 Minutes::2001
City by the Sea::2002
Analyze That::2002
Godsend::2003
Shark Tale::2004
Meet the Fockers::2004
The Bridge of San Luis Rey::2005
Rent::2005
Hide and Seek::2005
The Good Shepherd::2006
Arthur and the Invisibles::2007
Captain Shakespeare::2007
Righteous Kill::2008
What Just Happened?::2008
Everybody's Fine::2009
Machete::2010
Little Fockers::2010
Stone::2010
Killer Elite::2011
New Year's Eve::2011
Limitless::2011
Silver Linings Playbook::2012
Being Flynn::2012
Red Lights::2012
Last Vegas::2013
The Big Wedding::2013
Grudge Match::2013
Killing Season::2013
The Bag Man::2014
Joy::2015
Heist::2015
The Intern::2015
Dirty Grandpa::2016
Hands of Stone::2016
The Comedian::2016
The Wizard of Lies::2017
Joker::2019
The Irishman::2019
The War with Grandpa::2020
The Comeback Trail::2020
Amsterdam::2022
Savage Salvation::2022
Killers of the Flower Moon::2023
About My Father::2023
Ezra::2023
