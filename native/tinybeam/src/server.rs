use crate::atoms;
use rustler::Atom;


#[rustler::nif]
fn start() -> Atom {
  atoms::hi()
}
